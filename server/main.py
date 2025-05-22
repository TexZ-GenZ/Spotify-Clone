from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from database import engine
from models.base import Base
from routes import auth, song

app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

app.include_router(auth.router, prefix="/auth")
app.include_router(song.router, prefix="/song")

Base.metadata.create_all(engine)