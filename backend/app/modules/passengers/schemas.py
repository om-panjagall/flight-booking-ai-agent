from pydantic import BaseModel, ConfigDict  # type: ignore[import]
from datetime import date

class PassengerCreate(BaseModel):
    first_name: str
    last_name: str
    date_of_birth: date
    gender: str | None = None
    email: str | None = None
    phone: str | None = None
    passport_number: str
    nationality: str | None = None 

class PassengerUpdate(BaseModel):
    first_name: str | None = None
    last_name: str | None = None
    date_of_birth: date | None = None
    gender: str | None = None
    email: str | None = None
    phone: str | None = None
    passport_number: str | None = None
    nationality: str | None = None  

class PassengerSearch(BaseModel):
    first_name: str | None = None
    last_name: str | None = None
    email: str | None = None
    phone: str | None = None
    passport_number: str | None = None
    nationality: str | None = None

class PassengerResponse(BaseModel):
    id: int
    first_name: str
    last_name: str
    date_of_birth: date
    gender: str | None = None
    email: str | None = None
    phone: str | None = None
    passport_number: str
    nationality: str | None = None

    model_config = ConfigDict(from_attributes=True)