# ✈️ AI Flight Search Assistant

An AI-powered conversational flight search platform that allows users to search for flights using natural language.

The application combines a **Flutter frontend** with a **FastAPI backend**, **LangGraph/LangChain AI agent**, **Ollama local LLM**, and **PostgreSQL flight database**.

Instead of using a traditional flight search form, users can interact with the system naturally:

> Find flights from DXB to BLR

The AI agent understands the request, identifies the required flight-search parameters, validates them, invokes the flight search tool, retrieves matching flights from PostgreSQL, and generates a natural-language response.

---

# 📌 Project Status

> 🚧 **Active Development**

The current version focuses on the AI-powered conversational flight-search workflow.

Current core flow:

```text
Flutter
   │
   ▼
FastAPI
   │
   ▼
LangGraph AI Agent
   │
   ▼
Ollama / Qwen
   │
   ▼
Flight Search Tool
   │
   ▼
PostgreSQL
   │
   ▼
Flight Results
   │
   ▼
Ollama / Qwen
   │
   ▼
FastAPI
   │
   ▼
Flutter

**🏗️ System Architecture**

┌─────────────────────────────────────────────────────────┐
│                    Flutter Frontend                     │
│                                                         │
│  ┌───────────────────────────────────────────────────┐  │
│  │              AI Flight Search UI                  │  │
│  │                                                   │  │
│  │ "Find flights from DXB to BLR"                   │  │
│  └───────────────────────┬───────────────────────────┘  │
└──────────────────────────┼──────────────────────────────┘
                           │
                           │ REST API
                           ▼
┌─────────────────────────────────────────────────────────┐
│                    FastAPI Backend                      │
│                                                         │
│  ┌───────────────────────────────────────────────────┐  │
│  │              AI Chat API                          │  │
│  │          POST /api/v1/ai/chat                     │  │
│  └───────────────────────┬───────────────────────────┘  │
│                          │                              │
│                          ▼                              │
│  ┌───────────────────────────────────────────────────┐  │
│  │                LangGraph Agent                    │  │
│  │                                                   │  │
│  │  Understand → Validate → Tool → Respond         │  │
│  └───────────────┬───────────────────┬───────────────┘  │
│                  │                   │                  │
└──────────────────┼───────────────────┼──────────────────┘
                   │                   │
                   ▼                   ▼
        ┌─────────────────┐   ┌─────────────────────┐
        │     Ollama      │   │   Flight Search     │
        │                 │   │       Tool          │
        │   Qwen 2.5 3B  │   └──────────┬──────────┘
        └─────────────────┘              │
                                         ▼
                              ┌─────────────────────┐
                              │     PostgreSQL      │
                              │                     │
                              │    Flight Data      │
                              └─────────────────────┘


**🔄 Complete Request Flow**

For a request such as:

Find flights from DXB to BLR
1. User
   │
   ▼
2. Flutter AI Search Screen
   │
   ▼
3. HTTP POST /api/v1/ai/chat
   │
   ▼
4. FastAPI AI Route
   │
   ▼
5. AIAgent.ask()
   │
   ▼
6. LangGraph
   │
   ▼
7. Ollama / Qwen
   │
   ▼
8. AI determines that flight search is required
   │
   ▼
9. Tool-call validation
   │
   ▼
10. search_flights tool
    │
    ▼
11. Flight Service
    │
    ▼
12. SQLAlchemy
    │
    ▼
13. PostgreSQL
    │
    ▼
14. Flight Results
    │
    ▼
15. LangGraph
    │
    ▼
16. Ollama / Qwen
    │
    ▼
17. Natural-language response
    │
    ▼
18. FastAPI
    │
    ▼
19. Flutter
    │
    ▼
20. Display response to user

**📋 Project Components**

┌──────────────────────────────────────────────┐
│                  PROJECT                     │
├──────────────────────────────────────────────┤
│                                              │
│  Flutter Frontend                            │
│      │                                       │
│      ▼                                       │
│  FastAPI Backend                             │
│      │                                       │
│      ├── AI Routes                           │
│      ├── Flight Routes                       │
│      └── Application Services                │
│                                              │
│  AI Layer                                    │
│      │                                       │
│      ├── LangGraph                           │
│      ├── LangChain                           │
│      ├── Agent                               │
│      ├── Prompt                              │
│      ├── Memory                              │
│      └── Tool Calling                        │
│                                              │
│  LLM Layer                                   │
│      │                                       │
│      └── Ollama / Qwen 2.5 3B              │
│                                              │
│  Data Layer                                  │
│      │                                       │
│      ├── SQLAlchemy                          │
│      ├── Flight Service                      │
│      └── PostgreSQL                          │
│                                              │
│  Infrastructure                              │
│      │                                       │
│      ├── Docker                              │
│      └── Docker Compose                      │
│                                              │
└──────────────────────────────────────────────┘

**📌 Quick Start**

# Clone
git clone https://github.com/om-panjagall/flight-booking-ai-agent.git

# Start backend services
docker compose up -d --build

# Check services
docker compose ps

# Check Ollama
docker exec ollama ollama list

# Check loaded model
docker exec ollama ollama ps

# View backend logs
docker compose logs -f flight_backend

# View Ollama logs
docker compose logs -f ollama

