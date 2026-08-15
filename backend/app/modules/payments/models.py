from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Numeric
from app.core.database import Base

class Payment(Base):
    __tablename__ = "payments"

    id = Column(Integer, primary_key=True, index=True)
    booking_id = Column(Integer, ForeignKey("bookings.id"), nullable=False)
    amount = Column(Numeric(10, 2), nullable=False)
    transaction_id = Column(String(100), unique=True, nullable=False)
    payment_date = Column(DateTime, nullable=False)
    payment_method = Column(String(50), nullable=False)
    payment_status = Column(String(50), nullable=False)

    # Additional fields can be added here