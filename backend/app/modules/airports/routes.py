from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.core.database import get_db
from .schemas import ( 
    AirportCreate,
    AirportUpdate, 
    AirportResponse
)
from .service import AirportService 

router = APIRouter(
    prefix="/airports",
    tags=["airports"],
)

@router.post(
    "/", 
    response_model=AirportResponse,
)

def create_airport(
    airport: AirportCreate,
    db: Session = Depends(get_db),
):
    if AirportService.get_by_code(
        db, 
        airport.code
    ):
        raise HTTPException(
            status_code=400, 
            detail="Airport with this code already exists"
        )
    return AirportService.create(
        db, airport
    )

@router.get(
    "/",
    response_model=list[AirportResponse],
)
def get_airports(
    db: Session = Depends(get_db),
):
    return AirportService.get_all(db)   

@router.get(
    "/{airport_id}",
    response_model=AirportResponse,
)
def get_airport(
    airport_id: int,
    db: Session = Depends(get_db),
):
    airport = AirportService.get_by_id(
        db, 
        airport_id
    )
    if not airport:
        raise HTTPException(
            status_code=404, 
            detail="Airport not found"
        )
    return airport

@router.put(
    "/{airport_id}",
    response_model=AirportResponse,
)
def update_airport(
    airport_id: int,
    airport: AirportUpdate,
    db: Session = Depends(get_db),
):
    updated_airport = AirportService.update(
        db, 
        airport_id, 
        airport
    )
    if not updated_airport:
        raise HTTPException(
            status_code=404, 
            detail="Airport not found"
        )
    return updated_airport

@router.delete(
    "/{airport_id}",
    response_model=AirportResponse,
)
def delete_airport(
    airport_id: int,
    db: Session = Depends(get_db),
):
    deleted_airport = AirportService.delete(
        db, 
        airport_id
    )
    if not deleted_airport:
        raise HTTPException(
            status_code=404, 
            detail="Airport not found"
        )
    return {
        "message": "Airport deleted successfully."
    }