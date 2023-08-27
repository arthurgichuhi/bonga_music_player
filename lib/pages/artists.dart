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
    setState(() => musicFiles = ref.read(allMusicTrackProvider));
    getArtistData();
    ref.listen(allMusicTrackProvider, (previous, next) {
      setState(() => musicFiles = next);
      getArtistData();
    });
    super.initState();
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
      artists.toSet().toList();
    }
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
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: artists.length,
      itemBuilder: (context, index) => ArtistAlbums(
        artist: artists[index],
      ),
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
    setState(() => albums = ref
        .watch(musicFilePathMetadataProvider)
        .where((element) => element.values.first?.albumArtist == widget.artist)
        .first
        .keys
        .toSet()
        .toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: albums.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) => const _AlbumWidget(),
    );
  }
}

class _AlbumWidget extends StatelessWidget {
  const _AlbumWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
