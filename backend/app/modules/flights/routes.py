from sqlalchemy.orm import Session
from .schemas import FlightCreate, FlightUpdate, FlightResponse, FlightSearchResponse
from .service import FlightService
from app.core.database import get_db
from fastapi import APIRouter, Depends, HTTPException, status
from typing import List

router = APIRouter(
    prefix="/flights",
    tags=["flights"],
)

@router.post("/", response_model=FlightResponse)
def create_flight(flight: FlightCreate, db: Session = Depends(get_db)):
    return FlightService.create(db, flight)

@router.get("/", response_model=list[FlightResponse])
def get_flights(db: Session = Depends(get_db)):
    return FlightService.get_all(db)

# 🟢 PLACE THE SEARCH ROUTE HERE (Before /{flight_id})
@router.get("/search", response_model=list[FlightSearchResponse]) # 🟢 FIX: Changed response_model
def search_flights(
    source: str | None = None,
    destination: str | None = None,
    date: str | None = None,
    adults: int = 1,
    db: Session = Depends(get_db)
):
    return FlightService.search(
        db,
        source=source,
        destination=destination,
        date=date,
        adults=adults
    )

# 🔴 PLACE PATH PARAMETERS AFTER STATIC PATHS
@router.get("/{flight_id}", response_model=FlightResponse)
def get_flight(flight_id: int, db: Session = Depends(get_db)):
    flight = FlightService.get_by_id(db, flight_id)
    if not flight:
        raise HTTPException(status_code=404, detail="Flight not found")
    return flight

@router.put("/{flight_id}", response_model=FlightResponse)
def update_flight(flight_id: int, flight: FlightUpdate, db: Session = Depends(get_db)):
    updated_flight = FlightService.update(db, flight_id, flight)
    if not updated_flight:
        raise HTTPException(status_code=404, detail="Flight not found")
    return updated_flight

@router.delete("/{flight_id}", response_model=FlightResponse)
def delete_flight(flight_id: int, db: Session = Depends(get_db)):
    deleted_flight = FlightService.delete(db, flight_id)
    if not deleted_flight:
        raise HTTPException(status_code=404, detail="Flight not found")
    return deleted_flight

@router.post(
    "/bulk", 
    response_model=List[FlightResponse], 
    status_code=status.HTTP_201_CREATED,
    summary="Create multiple flights at once",
    description="Accepts an array of flight data and performs a bulk insert into the database."
)
def bulk_create_flights(
    flights: List[FlightCreate], 
    db: Session = Depends(get_db)
):
    # Optional: Basic validation check to catch incoming duplicate flight numbers in the same payload
    flight_numbers = [f.flight_number for f in flights]
    if len(flight_numbers) != len(set(flight_numbers)):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="The payload contains duplicate flight numbers."
        )
        
    try:
        inserted_flights = FlightService.create_multiple_flights(db, flights)
        return inserted_flights
    except Exception as e:
        # Rollback the transaction if the database unique constraint or foreign key check fails
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Database insertion failed. Error: {str(e)}"
        )

