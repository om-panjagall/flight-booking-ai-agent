from pydantic import BaseModel, ConfigDict  # type: ignore[import]

class AirportCreate(BaseModel):
    code: str
    name: str
    city: str
    country: str
    timezone: str | None = None

class AirportUpdate(BaseModel):
    name: str | None = None 
    city: str | None = None
    country: str | None = None
    timezone: str | None = None

class AirportResponse(BaseModel):
    id: int
    code: str
    name: str
    city: str
    country: str
    timezone: str | None

    model_config = ConfigDict(from_attributes=True)