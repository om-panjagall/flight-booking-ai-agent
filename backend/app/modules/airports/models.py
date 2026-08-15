from sqlalchemy import Column, Integer, String, Float, Boolean  # type: ignore[import]
from app.core.database import Base

class Airport(Base):
    __tablename__ = "airports"

    id = Column(Integer, primary_key=True, index=True)
    code = Column(String(10) , unique=True, index=True, nullable=False)  
    name = Column(String(200), nullable=False)
    city = Column(String(100), nullable=False)
    country = Column(String(100), nullable=False)
    timezone = Column(String(100), nullable=False)  
    