import 'dart:typed_data';
import 'package:bonga_music/api/songs.dart';
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
  //this functions music title data
  List<String> musicTitles = [];
  //this array holds the individual track artist
  List<String> trackArtists = [];
  //this array holds album data as extracted from the music files array data
  List<String> musicAlbums = [];
  //tis List holds duration data for each music file path
  List<double?> musicDuration = [];
  //this list holds the Album artist data
  List<String> albumArtists = [];
  //this list of type Map<String?,U8intlist?> holds the album name and picture data
  List<Uint8List?> albumArt = [];
  //this List holds the album Name,Artist Name,Music File path,Music Duration
  // and album Art data for sorting in the setupAlbumList function
  List<Map<String, dynamic>> inputDataSort = [];
  //this List holds data the album Name and file path data for music files used in sorting
  //this function holds the sorted data from the setupAlbumList function
  List<Map<String, dynamic>> outPutDataSort = [];

  @override
  void initState() {
    super.initState();
    //this section of code in initializing the music file path data from music folder
    MusicAPI().getLocalMusicFiles().then((value) async {
      setState(() {
        musicFiles = value;
      });
      //this sections retrieves song title data
      await MusicAPI()
          .getMusicTitles(musicFiles)
          .then((value) => setState(() => musicTitles = value));
      //this section creates a list of the album data from the music file path data
      await MusicAPI().getMusicAlbums(musicFiles).then((value) async {
        setState(() {
          musicAlbums = value;
        });
      });
      //this section sets the individual track artist data
      await MusicAPI()
          .getTrackArtist(musicFiles)
          .then((value) => setState(() => trackArtists = value));
      //this sections sets the album artist data
      await MusicAPI().getAlbumArtist(musicFiles).then((value) {
        setState(() {
          albumArtists = value;
        });
      });

      await MusicAPI()
          .getMusicDuration(musicFiles)
          .then((value) => setState(() => musicDuration = value));

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
      inputDataSort.add({
        'album': musicAlbums[x],
        'albumArtist': albumArtists[x],
        'albumArt': albumArt[x],
        'song': musicFiles[x],
        'duration': musicDuration[x],
        'title': musicTitles[x],
        'trackArtist': trackArtists[x]
      });
    }
    for (int x = 0; x <= uniqueAlbumList.length - 1; x++) {
      List<Uint8List?> albumArtIterable = [];
      List<String> albumMusicIterable = [];
      List<double?> albumDurationIterable = [];
      List<String> albumArtistIterable = [];
      List<String> musicTitlesIterable = [];
      List<String> trackArtistIterable = [];
      inputDataSort
          .where((element) => element['album'] == uniqueAlbumList[x])
          .forEach((element) {
        albumArtIterable.add(element['albumArt']);
        albumMusicIterable.add(element['song']);
        albumArtistIterable.add(element['albumArtist']);
        albumDurationIterable.add(element['duration']);
        musicTitlesIterable.add(element['title']);
        trackArtistIterable.add(element['trackArtist']);
      });
      outPutDataSort.add({
        'album': uniqueAlbumList[x],
        'albumArt': albumArtIterable[0],
        'albumArtist': albumArtistIterable[0],
        'songs': albumMusicIterable,
        'duration': albumDurationIterable,
        'title': musicTitlesIterable,
        'trackArtists': trackArtistIterable
      });
    }
    outPutDataSort.toSet().toList();

    for (var sorted in outPutDataSort) {
      debugPrint(
          '${sorted['album']}..............${sorted['songNo']}......${sorted['songs'].length}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: outPutDataSort.length ~/ 3.toInt(),
          itemBuilder: (context, index) {
            List<int> indexes = [0];
            if (index > 0) {
              for (int x = 1; x <= outPutDataSort.length ~/ 3.toInt(); x++) {
                indexes.add(index * 3);
              }
            }
            return Row(
              children: [
                AlbumWidget(
                  albumArt: outPutDataSort[indexes[index]]['albumArt'],
                  albumName: outPutDataSort[indexes[index]]['album'],
                  artist: outPutDataSort[indexes[index]]['albumArtist'],
                  songs: outPutDataSort[indexes[index]]['songs'],
                  songDuration: outPutDataSort[indexes[index]]['duration'],
                  musicTitles: outPutDataSort[indexes[index]]['title'],
                  trackArtist: outPutDataSort[indexes[index]]['trackArtists'],
                ),
                AlbumWidget(
                  albumArt: outPutDataSort[indexes[index] + 1]['albumArt'],
                  albumName: outPutDataSort[indexes[index] + 1]['album'],
                  artist: outPutDataSort[indexes[index] + 1]['albumArtist'],
                  songs: outPutDataSort[indexes[index] + 1]['songs'],
                  songDuration: outPutDataSort[indexes[index] + 1]['duration'],
                  musicTitles: outPutDataSort[indexes[index] + 1]['title'],
                  trackArtist: outPutDataSort[indexes[index] + 1]
                      ['trackArtists'],
                ),
                AlbumWidget(
                  albumArt: outPutDataSort[indexes[index] + 2]['albumArt'],
                  albumName: outPutDataSort[indexes[index] + 2]['album'],
                  artist: outPutDataSort[indexes[index] + 2]['albumArtist'],
                  songs: outPutDataSort[indexes[index] + 2]['songs'],
                  songDuration: outPutDataSort[indexes[index] + 2]['duration'],
                  musicTitles: outPutDataSort[indexes[index] + 2]['title'],
                  trackArtist: outPutDataSort[indexes[index] + 2]
                      ['trackArtists'],
                )
              ],
            );
          }),
    );
  }
}
