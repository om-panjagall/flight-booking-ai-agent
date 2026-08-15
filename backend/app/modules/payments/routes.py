from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends, HTTPException
from app.core.database import get_db
from .schemas import (
    PaymentCreate,
    PaymentUpdate,
    PaymentResponse
)
from .service import PaymentService

router = APIRouter(
    prefix="/payments",
    tags=["payments"],
)

@router.post(
    "/",
    response_model=PaymentResponse,
)
def create_payment(
    payment: PaymentCreate,
    db: Session = Depends(get_db),
):
    return PaymentService.create(db, payment)

@router.get(
    "/",
    response_model=list[PaymentResponse],
)
def get_payments(
    db: Session = Depends(get_db),
):
    return PaymentService.get_all(db)

@router.put(
    "/{payment_id}",
    response_model=PaymentResponse,
)
def update_payment(
    payment_id: int,
    payment: PaymentUpdate,
    db: Session = Depends(get_db),
):
    updated = PaymentService.update(db, payment_id, payment)
    if not updated:
        raise HTTPException(status_code=404, detail="Payment not found")
    return updated
