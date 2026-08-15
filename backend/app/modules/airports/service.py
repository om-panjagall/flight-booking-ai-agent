from sqlalchemy.orm import Session  # type: ignore[import]
from .models import Airport
from .schemas import AirportCreate, AirportUpdate

class AirportService:
    @staticmethod
    def create(db: Session, airport: AirportCreate):
        db_airport = Airport(**airport.model_dump())
        db.add(db_airport)
        db.commit()
        db.refresh(db_airport)
        return db_airport

    @staticmethod
    def get_all(db: Session):
        return (
            db.query(Airport)
            .order_by(Airport.city)
            .all())

    @staticmethod
    def get_by_id(db: Session, airport_id: int):
        return (
            db.query(Airport)
            .filter(Airport.id == airport_id)
            .first()
        )
    @staticmethod
    def get_by_code(db: Session, code: str):
        return (
            db.query(Airport)
            .filter(Airport.code == code.upper())
            .first()
        )

    @staticmethod
    def update(
        db: Session, 
        airport_id: int, 
        airport: AirportUpdate
    ):
        db_airport = AirportService.get_by_id(
            db, 
            airport_id
            )
        if not db_airport:
            return None
        for key, value in airport.model_dump(
            exclude_unset=True
            ).items():
                setattr(db_airport, key, value)
        db.commit()
        db.refresh(db_airport)
        return db_airport

    @staticmethod
    def delete(
        db: Session, 
        airport_id: int
    ):
        airport = AirportService.get_by_id(
            db, 
            airport_id
        )
        if not airport:
            return False
        db.delete(airport)
        db.commit()
        return True