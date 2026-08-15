from typing import Any

from langchain_core.tools import StructuredTool
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session
import time
import logging

from app.modules.flights.service import FlightService


logger = logging.getLogger(__name__)


class FlightSearchToolInput(BaseModel):
    source: str = Field(
        ...,
        description=(
            "Source airport code, city, or airport name. "
            "Examples: BLR, Bengaluru, Kempegowda International Airport."
        ),
    )

    destination: str = Field(
        ...,
        description=(
            "Destination airport code, city, or airport name. "
            "Examples: DXB, Dubai, Dubai International Airport."
        ),
    )

    date: str | None = Field(
        default=None,
        description=(
            "Departure date in YYYY-MM-DD format. "
            "Use null when the user did not provide a date."
        ),
    )

    adults: int = Field(
        default=1,
        ge=1,
        description="Number of adult passengers.",
    )


def create_flight_search_tool(db: Session) -> StructuredTool:
    """
    Create a LangChain tool that searches flights using the
    existing FlightService and PostgreSQL database.
    """

    def search_flights(
        source: str,
        destination: str,
        date: str | None = None,
        adults: int = 1,
    ) -> list[dict[str, Any]]:

        start_time = time.perf_counter()

        logger.info(
            "Flight search started: %s -> %s, date=%s, adults=%s",
            source,
            destination,
            date,
            adults,
        )

        results = FlightService.search(
            db=db,
            source=source,
            destination=destination,
            date=date,
            adults=adults,
        )

        elapsed = time.perf_counter() - start_time

        logger.info(
            "Flight search completed in %.2f seconds. Results=%d",
            elapsed,
            len(results),
        )

        return results

    return StructuredTool.from_function(
        func=search_flights,
        name="search_flights",
        description=(
            "Search available flights from the application's PostgreSQL "
            "database.\n\n"

            "REQUIRED PARAMETERS:\n"
            "- source: departure city, airport name, or IATA code. REQUIRED.\n"
            "- destination: arrival city, airport name, or IATA code. REQUIRED.\n"
            "- date: optional departure date in YYYY-MM-DD format.\n"
            "- adults: optional number of adult passengers, defaults to 1.\n\n"

            "IMPORTANT:\n"
            "Never call this tool unless BOTH source and destination "
            "are known from the conversation.\n"
            "If source is missing, ask the user for their departure "
            "city or airport.\n"
            "If destination is missing, ask the user for their destination "
            "city or airport."
        ),
        args_schema=FlightSearchToolInput,
    )