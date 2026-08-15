from sqlalchemy.orm import Session
from .models import Payment
from .schemas import PaymentCreate, PaymentUpdate

class PaymentService:
    @staticmethod
    def create(db: Session, payment: PaymentCreate):
        db_payment = Payment(**payment.model_dump())
        db.add(db_payment)
        db.commit()
        db.refresh(db_payment)
        return db_payment

    @staticmethod
    def get_all(db: Session):
        return (
            db.query(Payment)
            .order_by(Payment.payment_date)
            .all()
        )

    @staticmethod
    def get_by_id(db: Session, payment_id: int):
        return (
            db.query(Payment)
            .filter(Payment.id == payment_id)
            .first()
        )

    @staticmethod
    def update(
        db: Session, 
        payment_id: int, 
        payment: PaymentUpdate
    ):
        db_payment = PaymentService.get_by_id(
            db, 
            payment_id
            )
        if not db_payment:
            return None
        for key, value in payment.model_dump(
            exclude_unset=True
            ).items():
                setattr(db_payment, key, value)
        db.commit()
        db.refresh(db_payment)
        return db_payment

    @staticmethod
    def delete(
        db: Session, 
        payment_id: int
    ):
        db_payment = PaymentService.get_by_id(
            db, 
            payment_id
            )
        if not db_payment:
            return None
        db.delete(db_payment)
        db.commit()
        return db_payment