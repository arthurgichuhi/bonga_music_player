import 'dart:typed_data';
import 'package:bonga_music/database/playlists/playlist.dart';
import 'package:bonga_music/repositories/music_File_Paths_Provider.dart';
import 'package:bonga_music/screen/album_screen.dart';
import 'package:bonga_music/widgets/album_widget_playlist_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlbumWidget extends ConsumerWidget {
  const AlbumWidget(
      {super.key,
      required this.albumArt,
      required this.albumName,
      required this.artist,
      required this.songs,
      required this.songDuration,
      required this.musicTitles,
      required this.trackArtist,
      required this.playlists});
  final Uint8List? albumArt;
  final String? albumName;
  final String? artist;
  final List<String> songs;
  final List<double?> songDuration;
  final List<String> musicTitles;
  final List<String> trackArtist;
  final List<PlayLists> playlists;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // trackFilePaths.value = songs;
    return InkWell(
      onTap: () {
        ref
            .read(currentMusicFilePathsProvider.notifier)
            .update((state) => songs);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlbumViewScreen(
                albumArt: albumArt,
                albumName: albumName!,
                albumArtist: artist!,
                songs: songs,
                duration: songDuration,
                musicTitle: musicTitles,
                trackArtists: trackArtist,
              ),
            ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          albumArt != null
              ? SizedBox(
                  width: 114,
                  height: 114,
                  child: Image.memory(albumArt!),
                )
              : const SizedBox(
                  width: 114,
                  height: 114,
                  child: Icon(
                    CupertinoIcons.music_note,
                    size: 120,
                  ),
                ),
          const Divider(
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 2, top: 5),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 72,
                      child: Text(
                        albumName != null ? albumName! : 'Unknown',
                        style: const TextStyle(
                            fontSize: 13, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    SizedBox(
                        width: 72,
                        height: 30,
                        child: Text(
                          artist != null ? artist! : 'Unknown',
                          style: const TextStyle(
                              fontSize: 13, overflow: TextOverflow.ellipsis),
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: AlbumWidgetPlayListButton(
                    songs: songs,
                    playlists: playlists,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
