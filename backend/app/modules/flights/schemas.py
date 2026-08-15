from pydantic import BaseModel, ConfigDict, Field  # type: ignore[import]
from datetime import datetime, date
from enum import Enum
from .constants import FlightStatus

class FlightCreate(BaseModel):
    flight_number: str
    airline: str
    source_airport_id: int
    destination_airport_id: int
    departure_time: datetime
    arrival_time: datetime
    duration_minutes: int
    aircraft: str
    total_seats: int
    available_seats: int
    price: float
    status: FlightStatus

class FlightUpdate(BaseModel):
    flight_number: str | None = None
    airline: str | None = None
    source_airport_id: int | None = None
    destination_airport_id: int | None = None
    departure_time: datetime | None = None
    arrival_time: datetime | None = None
    duration_minutes: int | None = None
    aircraft: str | None = None
    total_seats: int | None = None
    available_seats: int | None = None
    price: float | None = None
    status: FlightStatus | None = None

class FlightSearchResponse(BaseModel):
    id: int
    flight_number: str
    airline: str
    source: str
    destination: str
    departure_time: datetime
    arrival_time: datetime
    price: float
    duration: str
    availableSeats: int

    class Config:
        from_attributes = True

class FlightResponse(BaseModel):
    id: int
    flight_number: str
    airline: str
    source_airport_id: int
    destination_airport_id: int
    departure_time: datetime
    arrival_time: datetime
    duration_minutes: int
    aircraft: str
    total_seats: int
    available_seats: int
    price: float
    status: FlightStatus

    model_config = ConfigDict(from_attributes=True)
    

