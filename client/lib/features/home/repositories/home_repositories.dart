import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repositories.g.dart';

@riverpod
HomeRepositories homeRepositories(Ref ref) {
  return HomeRepositories();
}

class HomeRepositories {
  Future<Either<Failure, String>> uploadSong({
    required String songName,
    required String songArtist,
    required File audioFile,
    required File imageFile,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${ServerConstants.baseUrl}/song/upload',
        ), // Replace with your API endpoint
      );

      request
        ..files.addAll([
          await http.MultipartFile.fromPath('song', audioFile.path),
          await http.MultipartFile.fromPath('thumbnail', imageFile.path),
        ])
        ..fields.addAll({
          'song_name': songName,
          'artist': songArtist,
          'hex_code': hexCode,
        })
        ..headers.addAll({'x-auth-token': token});

      final res = await request.send();
      if (res.statusCode != 201) {
        return Left(Failure(message: await res.stream.bytesToString()));
      }
      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<SongModel>>> getAllSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('${ServerConstants.baseUrl}/song/list'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      var resBodyMap = jsonDecode(res.body);
      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(Failure(message: resBodyMap['detail']));
      }
      resBodyMap = resBodyMap as List;

      List<SongModel> songs = [];
      for (final map in resBodyMap) {
        songs.add(SongModel.fromMap(map));
      }
      return Right(songs);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, bool>> favSong({
    required String token,
    required String songId,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${ServerConstants.baseUrl}/song/favourite'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
        body: jsonEncode({'song_id': songId}),
      );

      var resBodyMap = jsonDecode(res.body);
      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(Failure(message: resBodyMap['detail']));
      }

      return Right(resBodyMap['message']);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<SongModel>>> getAllFavSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('${ServerConstants.baseUrl}/song/list/favourites'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      var resBodyMap = jsonDecode(res.body);
      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(Failure(message: resBodyMap['detail']));
      }
      resBodyMap = resBodyMap as List;

      List<SongModel> songs = [];
      for (final map in resBodyMap) {
        songs.add(SongModel.fromMap(map['song']));
      }
      return Right(songs);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
