import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(getAllFavSongsProvider)
        .when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(
                child: Text(
                  'No Songs Found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: data.length + 1,
                itemBuilder: (context, index) {
                  if (index == data.length) {
                    return Material(
                      color: Pallete.borderColor.withAlpha(120),
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const UploadSongPage();
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: ListTile(
                            title: const Text(
                              "Upload New Song",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            leading: CircleAvatar(
                              backgroundColor: Pallete.backgroundColor
                                  .withAlpha(80),
                              radius: 35,
                              child: const Icon(
                                CupertinoIcons.plus,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  final song = data[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: Pallete.borderColor,
                      borderRadius: BorderRadius.circular(10),

                      child: InkWell(
                        onTap: () {
                          ref
                              .read(currentSongNotifierProvider.notifier)
                              .updateSong(song);
                        },

                        child: ListTile(
                          title: Text(
                            song.song_name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            song.artist,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(song.thumbnail_url),
                            radius: 35,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: Text(
                error.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
          loading: () {
            return const LoaderWidget();
          },
        );
  }
}
