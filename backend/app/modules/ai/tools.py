import logging
from typing import Any

import httpx

from app.core.config import settings

logger = logging.getLogger(__name__)


OLLAMA_BASE_URL = settings.OLLAMA_BASE_URL.rstrip("/")
OLLAMA_MODEL = settings.OLLAMA_MODEL


def call_ollama(
    messages: list[dict[str, Any]],
    tools: list[dict[str, Any]] | None = None,
) -> dict[str, Any]:

    url = f"{OLLAMA_BASE_URL}/api/chat"

    payload: dict[str, Any] = {
        "model": OLLAMA_MODEL,
        "messages": messages,
        "stream": False,
        "keep_alive": "30m",
        "options": {
            "num_ctx": 2048,
            "num_predict": 128,
            "temperature": 0.1,
        },
    }

    if tools:
        payload["tools"] = tools

    logger.info(
        "Calling Ollama model=%s url=%s",
        OLLAMA_MODEL,
        url,
    )

    timeout = httpx.Timeout(
        connect=10.0,
        read=300.0,
        write=30.0,
        pool=30.0,
    )

    try:
        with httpx.Client(timeout=timeout) as client:

            response = client.post(
                url,
                json=payload,
            )

            response.raise_for_status()

            data = response.json()

            logger.info(
                "Ollama response received"
            )

            if not isinstance(data, dict):
                raise RuntimeError(
                    "Unexpected Ollama response format"
                )

            return data

    except httpx.TimeoutException as exc:

        logger.exception(
            "Ollama request timed out"
        )

        raise RuntimeError(
            "Ollama request timed out. "
            "The local model is running slowly."
        ) from exc

    except httpx.HTTPError as exc:

        logger.exception(
            "Ollama HTTP request failed"
        )

        raise RuntimeError(
            f"Ollama HTTP error: {exc}"
        ) from exc