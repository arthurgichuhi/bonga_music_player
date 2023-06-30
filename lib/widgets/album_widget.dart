import 'dart:io';

import 'package:flutter/material.dart';

class AlbumWidget extends StatelessWidget {
  const AlbumWidget(
      {super.key,
      required this.file,
      required this.album_name,
      required this.artist,
      required this.number_of_songs});
  final File file;
  final String album_name;
  final String artist;
  final int number_of_songs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            child: Image.file(file),
          )
        ],
      ),
    );
  }
}
