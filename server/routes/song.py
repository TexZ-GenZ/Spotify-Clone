import uuid
import cloudinary
import cloudinary.uploader
from fastapi import APIRouter, Depends, File, Form, UploadFile
from sqlalchemy.orm import Session ,joinedload
from database import get_db
from middleware.auth_middleware import auth_middleware
from models.favourite import Favourite
from models.song import Song
from pydantic_schemas.favourite_song import FavouriteSong


router = APIRouter()

# Configuration       
cloudinary.config( 
    cloud_name = "dufruso0d", 
    api_key = "365943421947451", 
    api_secret = "nkHn9YWzAd1xZBWWllyPKv-s9y0", # Click 'View API Keys' above to copy your API secret
    secure=True
)

@router.post('/upload', status_code=201)
def upload_song(
    song: UploadFile = File(...),
    thumbnail: UploadFile = File(...),
    artist: str = Form(...),
    song_name: str = Form(...),
    hex_code: str = Form(...),
    db : Session = Depends(get_db),
    auth_dict = Depends(auth_middleware)
):
    song_id = str(uuid.uuid4())
    song_res = cloudinary.uploader.upload(song.file, resource_type="auto", folder= f"songs/{song_id}")
    thumbnail_res = cloudinary.uploader.upload(thumbnail.file, resource_type='image', folder=f"songs/{song_id}")

    new_song = Song(
        id = song_id,
        song_url = song_res['url'],
        thumbnail_url = thumbnail_res['url'],
        artist = artist,
        song_name = song_name,
        hex_code = hex_code
    )
    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return new_song


@router.get('/list')
def list_songs(
    db: Session = Depends(get_db),
    auth_dict = Depends(auth_middleware)
):
    songs = db.query(Song).all()
    return songs

@router.post('/favourite')
def favourite_song(
    song: FavouriteSong,
    db: Session = Depends(get_db),
    auth_dict = Depends(auth_middleware)
):
    user_id = auth_dict['uid']

    fav_song = db.query(Favourite).filter(
        Favourite.user_id == user_id,
        Favourite.song_id == song.song_id
    ).first()

    if fav_song:
        db.delete(fav_song)
        db.commit()
        return {
            'message': False
        }
    else:
        new_fav_song = Favourite(
            id = str(uuid.uuid4()),
            user_id = user_id,
            song_id = song.song_id
        )
        db.add(new_fav_song)
        db.commit()
        db.refresh(new_fav_song)
        return {
            'message': True
        }
    
@router.get('/list/favourites')
def list_fav_songs(
    db: Session = Depends(get_db),
    auth_dict = Depends(auth_middleware)
):
    user_id = auth_dict['uid']
    fav_songs = db.query(Favourite).filter(Favourite.user_id == user_id).options(
        joinedload(Favourite.song)
    ).all()

    return fav_songs