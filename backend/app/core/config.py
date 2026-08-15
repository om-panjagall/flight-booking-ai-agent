from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    PROJECT_NAME: str = "Flight Booking AI"

    API_V1_STR: str = "/api/v1"

    DATABASE_URL: str

    REDIS_URL: str

    CHROMA_HOST: str

    CHROMA_PORT: int

    OLLAMA_BASE_URL: str

    OLLAMA_MODEL: str = "llama2"

    AI_MOCK: bool = False

    SECRET_KEY: str

    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30

    ALGORITHM: str = "HS256"

    model_config = SettingsConfigDict(
        env_file=".env",
        case_sensitive=True,
    )


settings = Settings()