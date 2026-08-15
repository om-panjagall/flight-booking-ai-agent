from pydantic import BaseModel, ConfigDict  # type: ignore[import]
from datetime import datetime

class PaymentCreate(BaseModel):
    booking_id: int
    amount: float
    transaction_id: str
    payment_date: datetime
    payment_method: str
    payment_status: str

class PaymentUpdate(BaseModel):
    booking_id: int | None = None
    amount: float | None = None
    transaction_id: str | None = None
    payment_date: datetime | None = None
    payment_method: str | None = None
    payment_status: str | None = None

class PaymentResponse(BaseModel):
    id: int
    booking_id: int
    amount: float
    transaction_id: str
    payment_date: datetime
    payment_method: str
    payment_status: str

    model_config = ConfigDict(from_attributes=True)