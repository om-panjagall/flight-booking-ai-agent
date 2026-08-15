from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Numeric, Enum
from sqlalchemy.orm import declarative_base
from app.core.database import Base
from .constants import BookingStatus
from sqlalchemy.orm import relationship

class Booking(Base):
    __tablename__ = "bookings"

    id = Column(Integer, primary_key=True, index=True)
    flight_id = Column(Integer, ForeignKey("flights.id"), nullable=False)
    passenger_id = Column(Integer, ForeignKey("passengers.id"), nullable=False)
    seat_number = Column(String(10), nullable=False)
    booking_date = Column(DateTime, nullable=False)
    booking_status = Column(Enum(BookingStatus), default=BookingStatus.PENDING, nullable=False)
    fare = Column(Numeric(10, 2), nullable=False)

    # Relationships
    passenger = relationship("Passenger", foreign_keys=[passenger_id])
    flight = relationship("Flight", foreign_keys=[flight_id])
