from pydantic import BaseModel, ConfigDict, Field  # type: ignore[import]
from datetime import datetime

class BookingCreate(BaseModel):
    passenger_id: int | None = None
    passenger_name: str | None = None
    passenger_email: str | None = None
    passport_number: str | None = None
    flight_id: int | None = None
    flight_number: str | None = None
    seat_number: str
    booking_date: datetime
    booking_status: str = "Confirmed"
    fare: float

    model_config = ConfigDict(from_attributes=True)

class BookingUpdate(BaseModel):
    passenger_id: int | None = None
    flight_id: int | None = None
    seat_number: str | None = None
    booking_date: datetime | None = None
    booking_status: str | None = None
    fare: float | None = None

class BookingSearch(BaseModel):
    id: int
    passengerName: str     # We will concatenate first_name + last_name
    passportNumber: str
    flightNumber: str
    airline: str
    departure: str
    arrival: str
    seatNumber: str = Field(..., alias="seat_number")
    bookingDate: datetime = Field(..., alias="booking_date")
    status: str = Field(..., alias="booking_status")
    fare: float

    class Config:
        from_attributes = True
        populate_by_name = True

class BookingResponse(BaseModel):
    id: int
    passenger_id: int
    flight_id: int
    seat_number: str
    booking_date: datetime
    booking_status: str
    fare: float

    model_config = ConfigDict(from_attributes=True)