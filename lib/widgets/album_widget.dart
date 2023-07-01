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
  final String albumName;
  final String artist;
  final int songNo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          albumArt != null
              ? Image.memory(
                  albumArt!,
                  scale: 150,
                )
              : const Icon(
                  CupertinoIcons.music_note,
                  size: 150,
                ),
          const Divider(
            height: 1,
          ),
          Row(
            children: [
              Column(
                children: [Text(albumName), Text(artist)],
              ),
              Text(songNo.toString())
            ],
          )
        ],
      ),
    );
  }
}
