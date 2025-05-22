import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    final userFavourites = ref.watch(
      currentUserNotifierProvider.select((value) {
        return value!.favourites;
      }),
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [hexToColor(currentSong!.hex_code), const Color(0xff121212)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Pallete.transparentColor,

          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'assets/images/pull-down-arrow.png',
                color: Pallete.whiteColor,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Hero(
                tag: 'music-image',
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(currentSong.thumbnail_url),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.song_name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Pallete.whiteColor,
                            ),
                          ),
                          Text(
                            currentSong.artist,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Pallete.subtitleText,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () async {
                          await ref
                              .read(homeViewModelProvider.notifier)
                              .favSong(songId: currentSong.id);
                        },
                        icon: Icon(
                          userFavourites.any(
                                (element) => element.song_id == currentSong.id,
                              )
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,

                          color: Pallete.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder(
                    stream: songNotifier.audioPlayer!.positionStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final position = snapshot.data;
                      final duration = songNotifier.audioPlayer!.duration;
                      double progress = 0.0;
                      if (position != null && duration != null) {
                        progress =
                            position.inMilliseconds / duration.inMilliseconds;
                      }
                      return Column(
                        children: [
                          StatefulBuilder(
                            builder: (context, setState) {
                              return SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Pallete.whiteColor,
                                  inactiveTrackColor: Pallete.whiteColor
                                      .withAlpha(30),
                                  thumbColor: Pallete.whiteColor,
                                  trackHeight: 2.0,
                                  overlayShape: SliderComponentShape.noOverlay,
                                ),

                                child: Slider(
                                  min: 0,
                                  max: 1,
                                  value: progress,
                                  onChanged: (value) {
                                    progress = value;
                                    setState(() {});
                                  },
                                  onChangeEnd: (value) {
                                    songNotifier.seek(value);
                                  },
                                ),
                              );
                            },
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${position?.inMinutes}:${((position?.inSeconds ?? 0) % 60) < 10 ? '0' : ''}${(position?.inSeconds ?? 0) % 60}',
                                style: TextStyle(
                                  color: Pallete.subtitleText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                '1:30',
                                style: TextStyle(
                                  color: Pallete.subtitleText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/images/shuffle.png',
                              color: Pallete.whiteColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/images/previus-song.png',
                              color: Pallete.whiteColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              songNotifier.playPause();
                            },
                            icon: Icon(
                              songNotifier.isPlaying
                                  ? CupertinoIcons.pause_circle_fill
                                  : CupertinoIcons.play_circle_fill,
                              color: Pallete.whiteColor,
                              size: 80,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/images/next-song.png',
                              color: Pallete.whiteColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/images/repeat.png',
                              color: Pallete.whiteColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/images/connect-device.png',
                              color: Pallete.whiteColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              CupertinoIcons.list_bullet,
                              color: Pallete.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
