import 'dart:io';
import 'dart:ui';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/model/fav_song_model.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repositories/home_local_repositories.dart';
import 'package:client/features/home/repositories/home_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(Ref ref) async {
  final token = ref.watch(
    currentUserNotifierProvider.select((user) => user!.token),
  );
  final res = await ref
      .watch(homeRepositoriesProvider)
      .getAllSongs(token: token);

  final val = switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
  return val;
}

@riverpod
Future<List<SongModel>> getAllFavSongs(Ref ref) async {
  final token = ref.watch(
    currentUserNotifierProvider.select((user) => user!.token),
  );
  final res = await ref
      .watch(homeRepositoriesProvider)
      .getAllFavSongs(token: token);

  final val = switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
  return val;
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepositories _homeRepositories;
  late HomeLocalRepositories _homeLocalRepositories;

  @override
  AsyncValue? build() {
    _homeRepositories = ref.watch(homeRepositoriesProvider);
    _homeLocalRepositories = ref.watch(homeLocalRepositoriesProvider);
    return null;
  }

  Future<void> uploadSong({
    required String songName,
    required String songArtist,
    required File audioFile,
    required File imageFile,
    required Color selectedColor,
  }) async {
    state = const AsyncLoading();

    final res = await _homeRepositories.uploadSong(
      songName: songName,
      songArtist: songArtist,
      audioFile: audioFile,
      imageFile: imageFile,
      hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };

    print(val);
  }

  List<SongModel> getRecentlyPlayedSongs() {
    final songs = _homeLocalRepositories.loadSongs();
    return songs;
  }

  Future<void> favSong({required String songId}) async {
    state = const AsyncLoading();

    final res = await _homeRepositories.favSong(
      songId: songId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      Right(value: final r) => _favSongSuccess(r, songId),
    };

    print(val);
  }

  AsyncValue _favSongSuccess(bool isFav, String songId) {
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);
    if (isFav) {
      userNotifier.addUser(
        ref
            .read(currentUserNotifierProvider)!
            .copyWith(
              favourites: [
                ...ref.read(currentUserNotifierProvider)!.favourites,
                FavSongModel(id: '', song_id: songId, user_id: ''),
              ],
            ),
      );
    } else {
      userNotifier.addUser(
        ref
            .read(currentUserNotifierProvider)!
            .copyWith(
              favourites:
                  ref
                      .read(currentUserNotifierProvider)!
                      .favourites
                      .where((element) => element.song_id != songId)
                      .toList(),
            ),
      );
    }
    ref.invalidate(getAllFavSongsProvider);
    return state = AsyncValue.data(isFav);
  }
}
