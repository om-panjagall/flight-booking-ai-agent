from fastapi import FastAPI
from sqlalchemy import text

from app.core.database import Base, engine
from app.modules.airports.routes import router as airports_router
from app.modules.flights.routes import router as flights_router
from app.modules.passengers.routes import router as passengers_router
from app.modules.bookings.routes import router as bookings_router
from app.modules.payments.routes import router as payments_router
from app.modules.ai.routes import router as ai_router
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="Flight Agent API",
)

# --------------------------------------------------
# CORS
# --------------------------------------------------

app.add_middleware(
    CORSMiddleware,
    allow_origin_regex=r"http?://(localhost|127\.0\.0\.1)(:\d+)?$",
    # allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

Base.metadata.create_all(bind=engine)

@app.get("/")
def health_check():
    return {
        "status": "running",
        "application": "Flight Booking AI",
    }


@app.get("/db")
def database_status():
    with engine.connect() as connection:
        connection.execute(text("SELECT 1"))

    return {
        "database": "Connected"
    }

app.include_router( airports_router, prefix="/api/v1")
app.include_router( flights_router, prefix="/api/v1")
app.include_router( passengers_router, prefix="/api/v1")
app.include_router( bookings_router, prefix="/api/v1")
app.include_router( payments_router, prefix="/api/v1")
app.include_router( ai_router, prefix="/api/v1")
