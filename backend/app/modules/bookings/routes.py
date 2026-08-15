from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from app.core.database import get_db
from .schemas import (
    BookingCreate,
    BookingUpdate,
    BookingResponse,
    BookingSearch
)
from .service import BookingService 

router = APIRouter(
    prefix="/bookings",
    tags=["bookings"],
)

@router.post(
    "/",
    response_model=BookingResponse,
)
def create_booking(
    booking: BookingCreate,
    db: Session = Depends(get_db),
):
    return BookingService.create(
        db, booking
    )

@router.get(
    "/",
    response_model=list[BookingResponse],
)

def get_bookings(
    db: Session = Depends(get_db),
):
    return BookingService.get_all(db)

@router.get(
    "/{booking_id}",
    response_model=BookingResponse,
)
def get_booking(
    booking_id: int,
    db: Session = Depends(get_db),
):
    booking = BookingService.get_by_id(
        db, 
        booking_id
    )
    if not booking:
        raise HTTPException(
            status_code=404,
            detail="Booking not found"
        )
    return booking

@router.put(
    "/{booking_id}",
    response_model=BookingResponse,
)
def update_booking(
    booking_id: int,
    booking: BookingUpdate,
    db: Session = Depends(get_db),
):
    updated_booking = BookingService.update(
        db, 
        booking_id, 
        booking
    )
    if not updated_booking:
        raise HTTPException(
            status_code=404,
            detail="Booking not found"
        )
    return updated_booking

@router.get("/search", response_model=list[BookingSearch])
def search_bookings(
    passenger_name: str | None = None,
    passport_number: str | None = None,
    flight_number: str | None = None,
    status: str | None = Query(None, alias="status"),
    db: Session = Depends(get_db)
):
    return BookingService.search(
        db=db,
        passenger_name=passenger_name,
        passport_number=passport_number,
        flight_number=flight_number,
        status=status
    )

@router.delete(
    "/{booking_id}",
    response_model=BookingResponse,
)
def delete_booking(
    booking_id: int,
    db: Session = Depends(get_db),
):
    deleted_booking = BookingService.delete(
        db, 
        booking_id
    )
    if not deleted_booking:
        raise HTTPException(
            status_code=404,
            detail="Booking not found"
        )
    return deleted_booking