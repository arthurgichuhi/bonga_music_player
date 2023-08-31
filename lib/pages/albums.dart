import 'dart:typed_data';
import 'package:bonga_music/api/music_player_logic_operations.dart';
import 'package:bonga_music/database/db_api/db_operations_api.dart';
import 'package:bonga_music/database/playlists/playlist.dart';
import 'package:bonga_music/repositories/musicFilePathsProvider.dart';
import 'package:bonga_music/widgets/album_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';

class AlbumsList extends ConsumerStatefulWidget {
  const AlbumsList({super.key});

  @override
  ConsumerState<AlbumsList> createState() => _AlbumsListState();
}

class _AlbumsListState extends ConsumerState<AlbumsList> {
  //this array holds the file path data to music files in the music folder
  List<String> musicFiles = [];
  //Music files metadata
  List<Metadata?> musicFilesMetadata = [];
  //this array holds album data as extracted from the music files array data
  List<String> musicAlbums = [];
  //List of file paths and metadata
  List<Map<String, Metadata?>> filePathsMetadata = [];
  //this List holds the album Name,Artist Name,Music File path,Music Duration
  // and album Art data for sorting in the setupAlbumList function
  List<Map<String, dynamic>> inputDataSort = [];
  //this List holds data the album Name and file path data for music files used in sorting
  //this function holds the sorted data from the setupAlbumList function
  List<Map<String, dynamic>> outPutDataSort = [];
  //this function initilizes all user created playlists data
  Future<List<PlayLists>> getUserPlayListData() async {
    return await IsarDBServices().getListOfPlaylists();
  }

  //List of user playlists
  List<PlayLists> playLists = [];

  @override
  void initState() {
    debugPrint("Albums Page Init State");
    initializeMusicFiles();
    super.initState();
  }

//Intializes music files and their metadata
  void initializeMusicFiles() async {
    if (mounted) {
      //first checking whether if allMusicTrackProvider is empty and if so setting the
// music list to read from the database and if not read from the provider
      ref.read(allMusicTrackProvider).isEmpty
          ? await MusicAPI().getLocalMusicFiles().then((value) {
              setState(() => musicFiles = value);
              ref.read(allMusicTrackProvider.notifier).update((state) => value);
              debugPrint("Albums======Music==========${musicFiles.length}");
            })
          : setState(() => musicFiles = ref.read(allMusicTrackProvider));
      if (mounted) {
        //setting current track provider is current Track is empty
        ref.read(currentTrackProvider).isEmpty
            ? ref.read(currentTrackProvider.notifier).update((state) =>
                ref.read(allMusicTrackProvider).isNotEmpty
                    ? ref.read(allMusicTrackProvider)[0]
                    : musicFiles[0])
            : null;
      }
      //getting music metadata
      if (musicFiles.isNotEmpty && mounted) {
        ref.read(currentTrackProvider).isEmpty
            ? ref
                .read(currentTrackProvider.notifier)
                .update((state) => ref.read(allMusicTrackProvider)[0])
            : null;
        for (var musicFile in musicFiles) {
          await MusicAPI().getMusicMetaData(musicFile).then((value) {
            musicFilesMetadata.add(value);
            filePathsMetadata.add({musicFile: value});
          });
        }
        //settting current music file paths if it is empty
        ref.watch(currentMusicFilePathsProvider).isEmpty
            ? ref
                .read(currentMusicFilePathsProvider.notifier)
                .update((state) => musicFiles)
            : null;
      }
      //setting state of music file paths and metadata
      ref
          .read(musicFilePathMetadataProvider.notifier)
          .update((state) => filePathsMetadata);
      //getting individual albums
      for (var metadata in musicFilesMetadata) {
        musicAlbums.add(metadata?.album ?? "Unknown");
      }
      if (musicFiles.isNotEmpty) {
        setupAlbumList();
        getUserPlayListData()
            .then((value) => setState(() => playLists = value));
      }
    }
  }

  //this function section setups the album list
  void setupAlbumList() {
    List<String> uniqueAlbumList = musicAlbums.toSet().toList();
    for (int x = 0; x <= musicFilesMetadata.length - 1; x++) {
      inputDataSort.add({
        'album': musicFilesMetadata[x]?.album ?? "Unknown",
        'albumArtist': musicFilesMetadata[x]?.albumArtist ?? "Unknown",
        'albumArt': musicFilesMetadata[x]?.picture?.data,
        'song': musicFiles[x],
        'duration': musicFilesMetadata[x]?.durationMs,
        'title': musicFilesMetadata[x]?.title ?? "Unknown",
        'trackArtist': musicFilesMetadata[x]?.artist ?? "Unknown"
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
                  playlists: playLists,
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
                  playlists: playLists,
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
                  playlists: playLists,
                )
              ],
            );
          }),
    );
  }
}
