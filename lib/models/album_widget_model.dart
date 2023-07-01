import 'dart:typed_data';

class AlbumWidgetModel {
  final Uint8List albumArt;
  final String albumName;
  final String artist;
  final int songNo;

  AlbumWidgetModel(this.albumArt, this.albumName, this.artist, this.songNo);
}
