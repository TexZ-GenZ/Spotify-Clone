// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class SongModel {
  final String id;
  final String song_url;
  final String thumbnail_url;
  final String hex_code;
  final String artist;
  final String song_name;

  SongModel({
    required this.id,
    required this.song_url,
    required this.thumbnail_url,
    required this.hex_code,
    required this.artist,
    required this.song_name,
  });

  SongModel copyWith({
    String? id,
    String? song_url,
    String? thumbnail_url,
    String? hex_code,
    String? artist,
    String? song_name,
  }) {
    return SongModel(
      id: id ?? this.id,
      song_url: song_url ?? this.song_url,
      thumbnail_url: thumbnail_url ?? this.thumbnail_url,
      hex_code: hex_code ?? this.hex_code,
      artist: artist ?? this.artist,
      song_name: song_name ?? this.song_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'song_url': song_url,
      'thumbnail_url': thumbnail_url,
      'hex_code': hex_code,
      'artist': artist,
      'song_name': song_name,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] ?? '',
      song_url: map['song_url'] ?? '',
      thumbnail_url: map['thumbnail_url'] ?? '',
      hex_code: map['hex_code'] ?? '',
      artist: map['artist'] ?? '',
      song_name: map['song_name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) =>
      SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(id: $id, song_url: $song_url, thumbnail_url: $thumbnail_url, hex_code: $hex_code, artist: $artist, song_name: $song_name)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.song_url == song_url &&
        other.thumbnail_url == thumbnail_url &&
        other.hex_code == hex_code &&
        other.artist == artist &&
        other.song_name == song_name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        song_url.hashCode ^
        thumbnail_url.hashCode ^
        hex_code.hashCode ^
        artist.hashCode ^
        song_name.hashCode;
  }
}
