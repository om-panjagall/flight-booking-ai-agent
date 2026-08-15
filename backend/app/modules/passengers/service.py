from sqlalchemy.orm import Session
from .models import Passenger
from .schemas import PassengerCreate, PassengerUpdate

class PassengerService:
    @staticmethod
    def get_by_passport_number(db: Session, passport_number: str):
        return (
            db.query(Passenger)
            .filter(Passenger.passport_number == passport_number)
            .first()
        )

    @staticmethod
    def get_by_email(db: Session, email: str):
        return (
            db.query(Passenger)
            .filter(Passenger.email == email)
            .first()
        )

    @staticmethod
    def create(db: Session, passenger: PassengerCreate):
        db_passenger = Passenger(**passenger.model_dump())
        db.add(db_passenger)
        db.commit()
        db.refresh(db_passenger)
        return db_passenger

    @staticmethod
    def get_all(db: Session):
        return (
            db.query(Passenger)
            .order_by(Passenger.last_name, Passenger.first_name)
            .all()
        )

    @staticmethod
    def get_by_id(db: Session, passenger_id: int):
        return (
            db.query(Passenger)
            .filter(Passenger.id == passenger_id)
            .first()
        )

    @staticmethod
    def update(
        db: Session, 
        passenger_id: int, 
        passenger: PassengerUpdate
    ):
        db_passenger = PassengerService.get_by_id(
            db, 
            passenger_id
            )
        if not db_passenger:
            return None
        for key, value in passenger.model_dump(
            exclude_unset=True
            ).items():
                setattr(db_passenger, key, value)
        db.commit()
        db.refresh(db_passenger)
        return db_passenger


    @staticmethod
    def delete(
        db: Session, 
        passenger_id: int
    ):
        db_passenger = PassengerService.get_by_id(
            db, 
            passenger_id
            )
        if not db_passenger:
            return None
        db.delete(db_passenger) 
        db.commit()
        return db_passenger 