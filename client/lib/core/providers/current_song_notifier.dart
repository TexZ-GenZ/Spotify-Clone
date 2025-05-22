import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repositories/home_local_repositories.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  late HomeLocalRepositories _homeLocalRepositories;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;

  @override
  SongModel? build() {
    _homeLocalRepositories = ref.watch(homeLocalRepositoriesProvider);
    return null;
  }

  void updateSong(SongModel song) async {
    if (audioPlayer != null) {
      await audioPlayer!.stop();
      await audioPlayer!.dispose();
    }
    audioPlayer = AudioPlayer();

    audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
        isPlaying = false;

        this.state = this.state?.copyWith(hex_code: song.hex_code);
      }
    });

    final audioSource = AudioSource.uri(
      Uri.parse(song.song_url),
      tag: MediaItem(
        id: song.id,
        title: song.song_name,
        artist: song.artist,
        artUri: Uri.parse(song.thumbnail_url),
      ),
    );

    await audioPlayer!.setAudioSource(audioSource);

    _homeLocalRepositories.uploadLocalSong(song);
    audioPlayer!.play();
    isPlaying = true;
    state = song;
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
    isPlaying = !isPlaying;
    state = state?.copyWith(hex_code: state?.hex_code);
  }

  void seek(double val) {
    if (audioPlayer != null) {
      audioPlayer!.seek(
        Duration(
          milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt(),
        ),
      );
    }
  }
}
