import logging
from typing import TypedDict

from langchain_core.messages import AIMessage
from langchain_openai import ChatOpenAI
from langgraph.graph import END, START, StateGraph
from langgraph.prebuilt import ToolNode

from sqlalchemy.orm import Session
import time

from app.core.config import settings
from app.modules.ai.flight_tools import create_flight_search_tool
from app.modules.ai.memory import ConversationMemory
from app.modules.ai.prompts import SYSTEM_PROMPT


logger = logging.getLogger(__name__)


class AgentState(TypedDict):
    messages: list


class AIAgent:

    def __init__(
        self,
        db: Session,
        memory: ConversationMemory | None = None,
    ):
        self.db = db
        self.memory = memory or ConversationMemory()

        ollama_base_url = settings.OLLAMA_BASE_URL.rstrip("/")

        self.model = ChatOpenAI(
            model=settings.OLLAMA_MODEL,
            base_url=f"{ollama_base_url}/v1",
            api_key="ollama",
            temperature=0.0,
            timeout=120,
            max_retries=0,
        )

        self.flight_search_tool = create_flight_search_tool(db)

        self.tools = [
            self.flight_search_tool,
        ]

        self.model_with_tools = self.model.bind_tools(
            self.tools
        )

        self.tool_node = ToolNode(self.tools)

        self.graph = self._build_graph()

    def _build_graph(self):

        workflow = StateGraph(AgentState)

        # Agent node
        workflow.add_node(
            "agent",
            self._agent_node,
        )

        # Tool validation node
        workflow.add_node(
            "validate_tool_call",
            self._validate_tool_call,
        )

        # Actual tools node
        workflow.add_node(
            "tools",
            self.tool_node,
        )

        # START -> agent
        workflow.add_edge(
            START,
            "agent",
        )

        # Agent decides whether tools are required
        workflow.add_conditional_edges(
            "agent",
            self._should_use_tools,
            {
                "validate": "validate_tool_call",
                "end": END,
            },
        )

        # Validate tool call before ToolNode
        workflow.add_conditional_edges(
            "validate_tool_call",
            self._validate_tool_result,
            {
                "tools": "tools",
                "end": END,
            },
        )

        # Tool -> Agent
        workflow.add_edge(
            "tools",
            "agent",
        )

        return workflow.compile()

    def _agent_node(self, state: AgentState):

        messages = state["messages"]

        logger.info(
            "AI model call started. Messages: %d",
            len(messages),
        )

        start_time = time.perf_counter()

        response = self.model_with_tools.invoke(
            messages
        )

        elapsed = time.perf_counter() - start_time

        logger.info(
            "AI model call completed in %.2f seconds",
            elapsed,
        )

        tool_calls = getattr(response, "tool_calls", None)

        if tool_calls:
            logger.info(
                "AI generated tool calls: %s",
                tool_calls,
            )

        return {
            "messages": messages + [response]
        }

    def _should_use_tools(self, state: AgentState):

        messages = state["messages"]

        last_message = messages[-1]

        tool_calls = getattr(
            last_message,
            "tool_calls",
            None,
        )

        if tool_calls:
            return "validate"

        return "end"

    def _validate_tool_call(self, state: AgentState):

        messages = state["messages"]

        last_message = messages[-1]

        tool_calls = getattr(
            last_message,
            "tool_calls",
            None,
        )

        if not tool_calls:
            return {
                "messages": messages
            }

        # Currently we have one flight search tool.
        # Validate every generated tool call before execution.
        for tool_call in tool_calls:

            tool_name = tool_call.get("name")

            if tool_name != "search_flights":
                continue

            args = tool_call.get("args") or {}

            source = args.get("source")
            destination = args.get("destination")

            logger.info(
                "Validating flight search tool call: source=%s destination=%s args=%s",
                source,
                destination,
                args,
            )

            # Source missing
            if not source:

                logger.warning(
                    "Flight search tool call rejected: source is missing"
                )

                return {
                    "messages": messages + [
                        AIMessage(
                            content=(
                                "What is your departure city or airport?"
                            )
                        )
                    ]
                }

            # Destination missing
            if not destination:

                logger.warning(
                    "Flight search tool call rejected: destination is missing"
                )

                return {
                    "messages": messages + [
                        AIMessage(
                            content=(
                                "What is your destination city or airport?"
                            )
                        )
                    ]
                }

        return {
            "messages": messages
        }

    def _validate_tool_result(self, state: AgentState):

        messages = state["messages"]

        last_message = messages[-1]

        # If the validation node generated an AI response,
        # stop here instead of executing the invalid tool call.
        if isinstance(last_message, AIMessage):

            if not getattr(
                last_message,
                "tool_calls",
                None,
            ):
                return "end"

        return "tools"

    def ask(self, query: str) -> str:

        history = self.memory.get_history()

        messages = [
            {
                "role": "system",
                "content": SYSTEM_PROMPT,
            }
        ]

        messages.extend(history)

        messages.append(
            {
                "role": "user",
                "content": query,
            }
        )

        logger.info(
            "AI request: %s",
            query,
        )

        result = self.graph.invoke(
            {
                "messages": messages
            }
        )

        final_message = result["messages"][-1]

        answer = getattr(
            final_message,
            "content",
            "",
        )

        if isinstance(answer, list):
            answer = "".join(
                part.get("text", "")
                for part in answer
                if isinstance(part, dict)
            )

        answer = str(answer)

        self.memory.add_user_message(query)
        self.memory.add_assistant_message(answer)

        logger.info(
            "AI response generated successfully"
        )

        return answer