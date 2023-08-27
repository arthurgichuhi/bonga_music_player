import 'package:bonga_music/api/music_player_logic_operations.dart';
import 'package:bonga_music/repositories/music_File_Paths_Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArtistsPage extends ConsumerStatefulWidget {
  const ArtistsPage({super.key});

  @override
  ConsumerState<ArtistsPage> createState() => _ArtistsPageState();
}

class _ArtistsPageState extends ConsumerState<ArtistsPage> {
  List<String> musicFiles = [];
  List<String> artists = [];
  List<String> albums = [];
  @override
  void initState() {
    getAllMusicFiles();
    debugPrint("==========Artists Page Init=============${musicFiles.length}");

    super.initState();
  }

  //initialize music files
  void getAllMusicFiles() async {
    await MusicAPI()
        .getLocalMusicFiles()
        .then((value) => setState(() => musicFiles = value));
    debugPrint("==========Artists Page Init=============${musicFiles.length}");
    getArtistData();
  }

  //get artist data
  void getArtistData() {
    for (var data in musicFiles) {
      artists.add(ref
              .read(musicFilePathMetadataProvider)
              .where((element) => element.keys.first == data)
              .first
              .values
              .first
              ?.albumArtist ??
          "Unknown");
    }
    artists.toSet().toList();
    debugPrint("==============Get Artists Data============${artists.length}");
    getArtistAlbums();
  }

  //get artist albums
  void getArtistAlbums() {
    for (var file in musicFiles) {
      albums.add(ref
              .read(musicFilePathMetadataProvider)
              .where((element) => element.keys.first == file)
              .first
              .values
              .first
              ?.album ??
          "Unknown");
    }
    albums.toSet().toList();
    debugPrint("get artist album =========${albums.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: musicFiles.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: artists.length,
              itemBuilder: (context, index) => ArtistAlbums(
                artist: artists[index],
              ),
            )
          : CircularProgressIndicator(),
    );
  }
}

class ArtistAlbums extends ConsumerStatefulWidget {
  const ArtistAlbums({super.key, required this.artist});
  final String artist;

  @override
  ConsumerState<ArtistAlbums> createState() => _ArtistAlbumsState();
}

class _ArtistAlbumsState extends ConsumerState<ArtistAlbums> {
  List<String> albums = [];
  @override
  void initState() {
    //getting all albums from the artist
    ref
        .read(musicFilePathMetadataProvider)
        .where((element) => element.values.first?.albumArtist == widget.artist)
        .forEach((element) {
      albums.add(element.values.first?.album ?? "Unknown");
    });

    debugPrint("Albums-------------${albums.length}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row();
  }
}

class _AlbumWidget extends ConsumerWidget {
  const _AlbumWidget({required this.album});
  final String album;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      ref
              .read(musicFilePathMetadataProvider)
              .where((element) => element.values.first?.album == album)
              .isNotEmpty
          ? Image.memory(ref
              .read(musicFilePathMetadataProvider)
              .where((element) => element.values.first?.album == album)
              .first
              .values
              .first!
              .picture!
              .data)
          : const Icon(Icons.music_note),
      Text(album)
    ]);
  }
}
