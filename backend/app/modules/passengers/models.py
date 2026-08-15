from sqlalchemy import Column, Integer, String, Date, DateTime  # type: ignore[import]
from datetime import datetime, timezone
from sqlalchemy.orm import relationship  # type: ignore[import]
from app.core.database import Base

class Passenger(Base):
    __tablename__ = "passengers"

    id = Column(Integer, primary_key=True, index=True)
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    date_of_birth = Column(Date, nullable=False)

    # Additional fields can be added here
    gender = Column(String(20), nullable=True)
    email = Column(String(100), unique=True, index=True, nullable=True)
    phone = Column(String(20), nullable=True)
    passport_number = Column(String(50), unique=True, index=True, nullable=False)
    nationality = Column(String(100), nullable=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))


