from sqlalchemy import TEXT, Column, ForeignKey, Integer
from models.base import Base
from sqlalchemy.orm import relationship

class Favourite(Base):
    __tablename__ = 'favourites'
    id = Column(TEXT, primary_key=True)
    user_id = Column(TEXT, ForeignKey('users.id'), nullable=False)
    song_id = Column(TEXT, ForeignKey('songs.id'), nullable=False)

    song = relationship('Song')

    user = relationship('User', back_populates='favourites')