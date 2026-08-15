from enum import Enum


class FlightStatus(str, Enum):
    SCHEDULED = "Scheduled"
    DELAYED = "Delayed"
    CANCELLED = "Cancelled"
    BOARDING = "Boarding"
    COMPLETED = "Completed"