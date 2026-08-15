from operator import or_
from sqlalchemy import cast, Date
from sqlalchemy.orm import Session, aliased
from .models import Flight
from .schemas import FlightCreate, FlightUpdate
from app.modules.airports.models import Airport  # Adjust this import path to your layout
from datetime import datetime, date
from decimal import Decimal
import logging
from typing import List

logger = logging.getLogger(__name__)


class FlightService:
    @staticmethod
    def create(db: Session, flight: FlightCreate):
        db_flight = Flight(**flight.model_dump())
        db.add(db_flight)
        db.commit()
        db.refresh(db_flight)
        return db_flight

    @staticmethod
    def get_all(db: Session):
        return (
            db.query(Flight)
            .order_by(Flight.departure_time)
            .all()
        )

    @staticmethod
    def get_by_id(db: Session, flight_id: int):
        return (
            db.query(Flight)
            .filter(Flight.id == flight_id)
            .first()
        )

    @staticmethod
    def update(
        db: Session, 
        flight_id: int, 
        flight: FlightUpdate
    ):
        db_flight = FlightService.get_by_id(
            db, 
            flight_id
            )
        if not db_flight:
            return None
        for key, value in flight.model_dump(
            exclude_unset=True
            ).items():
                setattr(db_flight, key, value)
        db.commit()
        db.refresh(db_flight)
        return db_flight

    @staticmethod
    def delete(
        db: Session, 
        flight_id: int
    ):
        db_flight = FlightService.get_by_id(
            db, 
            flight_id
            )
        if not db_flight:
            return None
        db.delete(db_flight)
        db.commit()
        return db_flight

    @staticmethod
    def search(
        db: Session, 
        source: str | None = None,       
        destination: str | None = None,  
        date: str | None = None,
        adults: int = 1,
        flight_class: str | None = None
    ):
        try:
            query = db.query(Flight)

            # 1. Match source location properties via relationship
            if source:
                query = query.filter(
                    Flight.source_airport.has(
                        (Airport.code.ilike(f"%{source}%")) |
                        (Airport.city.ilike(f"%{source}%")) |
                        (Airport.name.ilike(f"%{source}%"))
                    )
                )
                
            # 2. Match destination location properties via relationship
            if destination:
                query = query.filter(
                    Flight.destination_airport.has(
                        (Airport.code.ilike(f"%{destination}%")) |
                        (Airport.city.ilike(f"%{destination}%")) |
                        (Airport.name.ilike(f"%{destination}%"))
                    )
                )

            # 3. Filter by Exact Departure Day Date
            if date:
                try:
                    target_date = datetime.strptime(date, "%Y-%m-%d").date()
                    query = query.filter(cast(Flight.departure_time, Date) == target_date)
                except ValueError:
                    pass 

            # 4. Filter by seat availability matching the number of adults requested
            if adults:
                query = query.filter(Flight.available_seats >= adults)

            flights = query.all()

            # 5. Build clean camelCase response dictionary array safely
            results = []
            for f in flights:
                hours = f.duration_minutes // 60
                minutes = f.duration_minutes % 60
                duration_str = f"{hours}h {minutes}m" if hours > 0 else f"{minutes}m"

                # FIX: Handle Decimal numeric fields by converting via string or ensuring safe cast
                price_val = float(str(f.price)) if isinstance(f.price, Decimal) else float(f.price)

                results.append({
                    "id": f.id,
                    "flight_number": f.flight_number,
                    "airline": f.airline,
                    "source": f.source_airport.code if f.source_airport else "",
                    "destination": f.destination_airport.code if f.destination_airport else "",
                    "departure_time": f.departure_time,
                    "arrival_time": f.arrival_time,
                    "price": price_val,
                    "duration": duration_str,
                    "available_seats": f.available_seats
                })

            return results

        except Exception as e:
            # This captures the hidden error and prints it to your terminal logs
            logger.error(f"CRITICAL CRASH IN FLIGHT SEARCH SERVICE: {str(e)}", exc_info=True)
            raise HTTPException(status_code=500, detail=f"Internal database mapping error: {str(e)}")

    @staticmethod
    def create_multiple_flights(db: Session, flights: List[FlightCreate]):
        # 1. Convert the list of Pydantic models into a list of SQLAlchemy model instances
        db_flights = [Flight(**flight.model_dump()) for flight in flights]
        
        # 2. Add all instances to the session at once
        db.add_all(db_flights)
        
        # 3. Commit the entire batch in a single database transaction
        db.commit()
        
        # 4. Refresh all objects to populate generated IDs from the database
        for db_flight in db_flights:
            db.refresh(db_flight)
            
        return db_flights
