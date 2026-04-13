from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.routers import api_router
from app.core.database import Base, engine
from app.models import test, user, other, course, home, notification # Registering all models with SQLAlchemy Base

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    openapi_url=f"{settings.API_V1_STR}/openapi.json"
)

# Mount static files
import os
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.on_event("startup")
async def startup_event():
    logger.info("Starting up Domus API...")
    # This automatically creates all tables defined in models if they don't exist
    Base.metadata.create_all(bind=engine)
    logger.info("Database tables verified/created.")
    os.makedirs("uploads/profile_pics", exist_ok=True)
    logger.info("Uploads directory verified.")

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
