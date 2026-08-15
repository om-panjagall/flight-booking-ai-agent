import logging

from fastapi import APIRouter, Depends
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.database import get_db
from app.modules.ai.agent import AIAgent


logger = logging.getLogger(__name__)


router = APIRouter(
    prefix="/ai",
    tags=["AI"],
)


class AIChatRequest(BaseModel):

    query: str = Field(
        ...,
        min_length=1,
        max_length=2000,
    )


class AIChatResponse(BaseModel):

    query: str

    answer: str


@router.post(
    "/chat",
    response_model=AIChatResponse,
)
def chat(
    request: AIChatRequest,
    db: Session = Depends(get_db),
):

    if settings.AI_MOCK:

        return AIChatResponse(
            query=request.query,
            answer=(
                "[Mock AI] I can help you search flights, "
                "compare flights, and plan your trip."
            ),
        )

    try:

        agent = AIAgent(
            db=db,
        )

        answer = agent.ask(
            request.query
        )

        return AIChatResponse(
            query=request.query,
            answer=answer,
        )

    except Exception as exc:

        logger.exception(
            "AI request failed"
        )

        return AIChatResponse(
            query=request.query,
            answer=(
                "AI temporarily encountered an error. "
                "Please try again."
            ),
        )