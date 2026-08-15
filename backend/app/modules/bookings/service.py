from datetime import date

from fastapi import HTTPException
from sqlalchemy.orm import Session
from .models import Booking
from app.modules.passengers.models import Passenger  
from app.modules.flights.models import Flight
from app.modules.passengers.service import PassengerService
from app.modules.passengers.schemas import PassengerCreate
from .schemas import BookingCreate, BookingUpdate

class BookingService:
    @staticmethod
    def create(db: Session, booking: BookingCreate):
        # Resolve flight_id from flight_number if only flight_number is provided
        if booking.flight_id is None:
            if booking.flight_number:
                flight = (
                    db.query(Flight)
                    .filter(Flight.flight_number.ilike(booking.flight_number))
                    .first()
                )
                if not flight:
                    raise HTTPException(status_code=422, detail="Flight not found for booking")
                booking.flight_id = flight.id
            else:
                raise HTTPException(status_code=422, detail="flight_id or flight_number is required")

        # Resolve or create passenger_id from passenger_email if needed
        if booking.passenger_id is None:
            if booking.passenger_email:
                passenger = PassengerService.get_by_email(db, booking.passenger_email)
                if not passenger:
                    if not booking.passenger_name or not booking.passport_number:
                        raise HTTPException(
                            status_code=422,
                            detail="passenger_name, passenger_email, and passport_number are required for a new passenger",
                        )
                    first_name = booking.passenger_name.split(" ", 1)[0]
                    last_name = booking.passenger_name.split(" ", 1)[1] if " " in booking.passenger_name else ""
                    new_passenger = PassengerCreate(
                        first_name=first_name,
                        last_name=last_name,
                        date_of_birth=date(2000, 1, 1),
                        email=booking.passenger_email,
                        passport_number=booking.passport_number,
                    )
                    passenger = PassengerService.create(db, new_passenger)
                booking.passenger_id = passenger.id
            else:
                raise HTTPException(status_code=422, detail="passenger_id or passenger_email is required")

        create_data = {
            "passenger_id": booking.passenger_id,
            "flight_id": booking.flight_id,
            "seat_number": booking.seat_number,
            "booking_date": booking.booking_date,
            "booking_status": booking.booking_status,
            "fare": booking.fare,
        }

        db_booking = Booking(**create_data)
        db.add(db_booking)
        db.commit()
        db.refresh(db_booking)
        return db_booking

    @staticmethod
    def get_all(db: Session):
        bookings = (
            db.query(Booking)
            .order_by(Booking.booking_date)
            .all()
        )

        results = []
        for b in bookings:
            p_name = f"{b.passenger.first_name} {b.passenger.last_name}" if b.passenger else "Unknown"
            passport = b.passenger.passport_number if b.passenger else "Unknown"
            email = b.passenger.email if b.passenger else ""
            f_num = b.flight.flight_number if b.flight else "Unknown"
            airline = b.flight.airline if b.flight else ""
            departure = b.flight.source_airport.code if b.flight and b.flight.source_airport else ""
            arrival = b.flight.destination_airport.code if b.flight and b.flight.destination_airport else ""

            results.append({
                "id": b.id,
                "passenger_id": b.passenger_id,
                "flight_id": b.flight_id,
                "passenger_name": p_name,
                "passenger_email": email,
                "passport_number": passport,
                "flight_number": f_num,
                "airline": airline,
                "departure": departure,
                "arrival": arrival,
                "seat_number": b.seat_number,
                "booking_date": b.booking_date,
                "booking_status": b.booking_status.name if hasattr(b.booking_status, "name") else str(b.booking_status),
                "fare": float(b.fare),
            })

        return results

    @staticmethod
    def get_by_id(db: Session, booking_id: int):
        return (
            db.query(Booking)
            .filter(Booking.id == booking_id)
            .first()
        )

    @staticmethod
    def update(
        db: Session, 
        booking_id: int, 
        booking: BookingUpdate
    ):
        db_booking = BookingService.get_by_id(
            db, 
            booking_id
            )
        if not db_booking:
            return None
        for key, value in booking.model_dump(
            exclude_unset=True
            ).items():
                setattr(db_booking, key, value)
        db.commit()
        db.refresh(db_booking)
        return db_booking

    @staticmethod
    def delete(
        db: Session, 
        booking_id: int
    ):
        db_booking = BookingService.get_by_id(
            db, 
            booking_id
            )
        if not db_booking:
            return None
        db.delete(db_booking)


    @staticmethod
    def search(
        db: Session,
        passenger_name: str | None = None,
        passport_number: str | None = None,
        flight_number: str | None = None,
        status: str | None = None
    ):
        query = db.query(Booking)

        # 1. Search by Passenger Name (first or last name matches)
        if passenger_name:
            query = query.filter(
                Booking.passenger.has(
                    (Passenger.first_name.ilike(f"%{passenger_name}%")) |
                    (Passenger.last_name.ilike(f"%{passenger_name}%"))
                )
            )

        # 2. Search by Passport Number
        if passport_number:
            query = query.filter(
                Booking.passenger.has(Passenger.passport_number.ilike(f"%{passport_number}%"))
            )

        # 3. Search by Flight Number (e.g., "AI202")
        if flight_number:
            query = query.filter(
                Booking.flight.has(Flight.flight_number.ilike(f"%{flight_number}%"))
            )

        # 4. Search by Booking Status (e.g., "CONFIRMED")
        if status:
            query = query.filter(Booking.booking_status == status)

        bookings = query.all()

        # 5. Transform database rows into clean JSON dictionary values
        results = []
        for b in bookings:
            # Safely build passenger full name string
            p_name = f"{b.passenger.first_name} {b.passenger.last_name}" if b.passenger else "Unknown"
            passport = b.passenger.passport_number if b.passenger else "Unknown"
            f_num = b.flight.flight_number if b.flight else "Unknown"

            results.append({
                "id": b.id,
                "passengerName": p_name,
                "passportNumber": passport,
                "flightNumber": f_num,
                "seat_number": b.seat_number,
                "booking_date": b.booking_date,
                "booking_status": b.booking_status.name if hasattr(b.booking_status, "name") else str(b.booking_status),
                "fare": float(b.fare)
            })

        return results