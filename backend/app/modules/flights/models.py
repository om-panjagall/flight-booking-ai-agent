from sqlalchemy import Column, Integer, String, DateTime, Float, Boolean, ForeignKey, Numeric, Enum
from app.core.database import Base
from sqlalchemy.orm import relationship
import enum
from .constants import FlightStatus

class Flight(Base):
    __tablename__ = "flights"

    id = Column(Integer, primary_key=True, index=True)
    flight_number = Column(String(20), unique=True, index=True, nullable=False)
    airline = Column(String(100), nullable=False)

    source_airport_id = Column(Integer, ForeignKey("airports.id"), nullable=False)
    destination_airport_id = Column(Integer, ForeignKey("airports.id"), nullable=False)

    departure_time = Column(DateTime, nullable=False)
    arrival_time = Column(DateTime, nullable=False)
    duration_minutes = Column(Integer, nullable=False)

    aircraft = Column(String(100), nullable=False)
    total_seats = Column(Integer, nullable=False)
    available_seats = Column(Integer, nullable=False)

    price = Column(Numeric(10, 2), nullable=False)
    status = Column(Enum(FlightStatus), default=FlightStatus.SCHEDULED, nullable=False)

    # Relationships
    source_airport = relationship("Airport", foreign_keys=[source_airport_id])
    destination_airport = relationship("Airport", foreign_keys=[destination_airport_id])