from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.core.database import get_db
from .schemas import ( 
    PassengerCreate,
    PassengerUpdate, 
    PassengerResponse
)
from .service import PassengerService 

router = APIRouter(
    prefix="/passengers",
    tags=["passengers"],
)  

@router.post(
    "/", 
    response_model=PassengerResponse,
)
def create_passenger(
    passenger: PassengerCreate,
    db: Session = Depends(get_db),
):
    if PassengerService.get_by_passport_number(
        db, 
        passenger.passport_number
    ):
        raise HTTPException(
            status_code=400, 
            detail="Passenger with this passport number already exists"
        )
    return PassengerService.create(
        db, passenger
    )   

@router.get(
    "/",
    response_model=list[PassengerResponse],
)
def get_passengers(
    db: Session = Depends(get_db),
):
    return PassengerService.get_all(db)

@router.get(
    "/{passenger_id}",
    response_model=PassengerResponse,
)
def get_passenger(  
    passenger_id: int,
    db: Session = Depends(get_db),
):
    passenger = PassengerService.get_by_id(
        db, 
        passenger_id
    )
    if not passenger:
        raise HTTPException(
            status_code=404, 
            detail="Passenger not found"
        )
    return passenger

@router.put(
    "/{passenger_id}",
    response_model=PassengerResponse,
)
def update_passenger(
    passenger_id: int,
    passenger: PassengerUpdate,
    db: Session = Depends(get_db),
):
    updated_passenger = PassengerService.update(
        db, 
        passenger_id, 
        passenger
    )
    if not updated_passenger:
        raise HTTPException(
            status_code=404, 
            detail="Passenger not found"
        )
    return updated_passenger

@router.delete(
    "/{passenger_id}",
    response_model=PassengerResponse,
)
def delete_passenger(
    passenger_id: int,
    db: Session = Depends(get_db),
):
    deleted_passenger = PassengerService.delete(
        db, 
        passenger_id
    )
    if not deleted_passenger:
        raise HTTPException(
            status_code=404, 
            detail="Passenger not found"
        )
    return deleted_passenger    