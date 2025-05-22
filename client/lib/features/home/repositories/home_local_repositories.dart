import 'package:client/features/home/model/song_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_local_repositories.g.dart';

@riverpod
HomeLocalRepositories homeLocalRepositories(Ref ref) {
  return HomeLocalRepositories();
}

class HomeLocalRepositories {
  final Box box = Hive.box();

  void uploadLocalSong(SongModel song) {
    box.put(song.id, song.toJson());
  }

  List<SongModel> loadSongs() {
    List<SongModel> songs = [];
    for (var key in box.keys) {
      final songData = box.get(key);
      if (songData != null) {
        songs.add(SongModel.fromJson(songData));
      }
    }
    return songs;
  }
}
