import 'dart:typed_data';
import 'package:bonga_music/screen/album_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlbumWidget extends StatelessWidget {
  const AlbumWidget(
      {super.key,
      required this.albumArt,
      required this.albumName,
      required this.artist,
      required this.songs,
      required this.songDuration,
      required this.musicTitles,
      required this.trackArtist});
  final Uint8List? albumArt;
  final String? albumName;
  final String? artist;
  final List<String> songs;
  final List<double?> songDuration;
  final List<String> musicTitles;
  final List<String> trackArtist;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
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
          )),
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
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
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 114,
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
                        width: 114,
                        height: 30,
                        child: Text(
                          artist != null ? artist! : 'Unknown',
                          style: const TextStyle(
                              fontSize: 13, overflow: TextOverflow.ellipsis),
                        ))
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
