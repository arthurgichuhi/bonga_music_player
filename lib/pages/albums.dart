import 'dart:typed_data';

import 'package:bonga_music/api/songs.dart';
import 'package:bonga_music/models/album_widget_model.dart';
import 'package:bonga_music/theme.dart';
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
  List<Map<String?, Uint8List?>> albumArt = [];
  //this List holds AlbumWidgetModel data type
  List<AlbumWidgetModel> albumWidgetData = [];

  @override
  void initState() {
    super.initState();
    //this section of code in initializing the music file path data from music folder
    MusicAPI().getLocalMusicFiles().then((value) {
      setState(() {
        musicFiles = value;
      });
      //this section creates a list of the album data from the music file path data
      MusicAPI().getMusicAlbums(musicFiles).then((value) {
        setState(() {
          musicAlbums = value;
        });
      });
      //this sections sets the album artist data
      MusicAPI().getAlbumArtist(musicFiles).then((value) {
        setState(() {
          albumArtists = value;
        });
      });

      //this section retrieves the album name data and picture in map format
      MusicAPI().getAlbumArt(musicFiles).then((value) {
        setState(() {
          albumArt = value;
        });
      });
      //this section sets the number albums
      if (musicAlbums.isNotEmpty) {
        //first filter the music album data to unique values
        var uniqueMusicAlbumsData = musicAlbums.toSet().toList();
        //second dividing the numbe of the new unique albums number by 3
        //since every row of the list will only have 3 albums
        var number = uniqueMusicAlbumsData.length ~/ 3;
        setState(() {
          albumNo = number.toInt();
        });
      }
    });
  }
  //this function section setups the album list

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: albumNo,
        itemBuilder: (context, index) => Card(
          color: AppColors.accent,
        ),
      ),
    );
  }
}
