import os
import logging

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.routers import api_router
from app.core.database import Base, engine
from app.models import test, user, other, course, home, notification # Registering all models with SQLAlchemy Base

# Ensure uploads directory exists before mounting
os.makedirs("uploads/profile_pics", exist_ok=True)

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    openapi_url=f"{settings.API_V1_STR}/openapi.json"
)

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.on_event("startup")
async def startup_event():
    logger.info("Starting up Domus API...")
    
    # Retry logic for database connection
    import time
    max_retries = 5
    retry_interval = 5
    
    for i in range(max_retries):
        try:
            # This automatically creates all tables defined in models if they don't exist
            Base.metadata.create_all(bind=engine)
            logger.info("Database tables verified/created.")
            break
        except Exception as e:
            if i < max_retries - 1:
                logger.warning(f"Database connection failed (attempt {i+1}/{max_retries}). Retrying in {retry_interval}s... Error: {e}")
                time.sleep(retry_interval)
            else:
                logger.error(f"Database connection failed after {max_retries} attempts. Starting app without DB verification.")
    
    logger.info("Startup complete.")

app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")

# Set up CORS (add after mounting to ensure it wraps the static files app)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(api_router, prefix=settings.API_V1_STR)

@app.get("/")
def root():
    return {"message": "Welcome to Domus API"}
