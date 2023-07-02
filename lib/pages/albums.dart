import 'dart:typed_data';
import 'package:bonga_music/api/songs.dart';
import 'package:bonga_music/models/album_widget_model.dart';
import 'package:bonga_music/theme.dart';
import 'package:bonga_music/widgets/album_widget.dart';
import 'package:flutter/material.dart';

class AlbumsList extends StatefulWidget {
  const AlbumsList({super.key});

  @override
  State<AlbumsList> createState() => _AlbumsListState();
}

class _AlbumsListState extends State<AlbumsList> {
  //this array holds the file path data to music files in the music folder
  List<String> musicFiles = [];
  //this array holds album data as extracted from the music files array data
  List<String> musicAlbums = [];
  //this integer holds the number of albums to control the length of the list
  int albumNo = 0;
  //this list holds the Album artist data
  List<String> albumArtists = [];
  //this list of type Map<String?,U8intlist?> holds the album name and picture data
  List<Uint8List?> albumArt = [];
  //this List holds AlbumWidgetModel data type
  List<Map<String, dynamic>> albumNameArt = [];
  List<Map<String, dynamic>> albumsSongCount = [];

  @override
  void initState() {
    super.initState();
    //this section of code in initializing the music file path data from music folder
    MusicAPI().getLocalMusicFiles().then((value) async {
      setState(() {
        musicFiles = value;
      });
      //this section creates a list of the album data from the music file path data
      await MusicAPI().getMusicAlbums(musicFiles).then((value) async {
        setState(() {
          musicAlbums = value;
        });
      });
      //this sections sets the album artist data
      await MusicAPI().getAlbumArtist(musicFiles).then((value) {
        setState(() {
          albumArtists = value;
        });
      });

      //this section retrieves the album name data and picture in map format
      await MusicAPI().getAlbumArt(musicFiles).then((value) {
        setState(() {
          albumArt = value;
        });
      });
      setupAlbumList();
    });
  }

  //this function section setups the album list
  void setupAlbumList() {
    List<String> uniqueAlbumList = musicAlbums.toSet().toList();
    for (int x = 0; x <= albumArt.length - 1; x++) {
      albumNameArt.add({
        'album': musicAlbums[x],
        'albumArtist': albumArtists[x],
        'albumArt': albumArt[x]
      });
    }
    for (int x = 0; x <= uniqueAlbumList.length - 1; x++) {
      var counter =
          musicAlbums.where((element) => element == uniqueAlbumList[x]);
      var albumArtIterable = albumNameArt
          .where((element) => element['album'] == uniqueAlbumList[x]);

      albumsSongCount.add({
        'album': uniqueAlbumList[x],
        'songNo': counter.length,
        'albumArt': albumArtIterable.first['albumArt'],
        'albumArtist': albumArtIterable.first['albumArtist']
      });
    }
    albumsSongCount.toSet().toList();

    for (var sorted in albumsSongCount) {
      debugPrint(
          '${sorted['album']}..............${sorted['songNo']}......${sorted['albumArt'].runtimeType}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: albumsSongCount.length ~/ 3.toInt(),
          itemBuilder: (context, index) {
            int indexAdd = index;
            if (index > 0) {
              indexAdd = index + 3;
            }
            return Row(
              children: [
                AlbumWidget(
                    albumArt: albumsSongCount[indexAdd]['albumArt'],
                    albumName: albumsSongCount[indexAdd]['album'],
                    artist: albumsSongCount[indexAdd]['albumArtist'],
                    songNo: albumsSongCount[indexAdd]['songNo']),
                AlbumWidget(
                    albumArt: albumsSongCount[indexAdd + 1]['albumArt'],
                    albumName: albumsSongCount[indexAdd + 1]['album'],
                    artist: albumsSongCount[indexAdd + 1]['albumArtist'],
                    songNo: albumsSongCount[indexAdd + 1]['songNo']),
                AlbumWidget(
                    albumArt: albumsSongCount[indexAdd + 2]['albumArt'],
                    albumName: albumsSongCount[indexAdd + 2]['album'],
                    artist: albumsSongCount[indexAdd + 2]['albumArtist'],
                    songNo: albumsSongCount[indexAdd + 2]['songNo'])
              ],
            );
          }),
    );
  }
}
