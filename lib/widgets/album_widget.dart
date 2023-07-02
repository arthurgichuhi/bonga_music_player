import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlbumWidget extends StatelessWidget {
  const AlbumWidget(
      {super.key,
      required this.albumArt,
      required this.albumName,
      required this.artist,
      required this.songNo});
  final Uint8List? albumArt;
  final String? albumName;
  final String? artist;
  final int? songNo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2),
      child: SizedBox(
        height: 190,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            albumArt != null
                ? Image.memory(
                    albumArt!,
                    scale: 11,
                  )
                : const Icon(
                    CupertinoIcons.music_note,
                    size: 90,
                  ),
            const Divider(
              height: 1,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints.tight(Size(100, 30)),
                      child: Text(
                        albumName != null ? albumName! : '',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(artist != null ? artist! : '')
                  ],
                ),
                Text(songNo.toString())
              ],
            )
          ],
        ),
      ),
    );
  }
}
