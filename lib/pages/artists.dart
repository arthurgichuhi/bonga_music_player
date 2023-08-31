import 'package:bonga_music/repositories/musicFilePathsProvider.dart';
import 'package:bonga_music/screen/artist_works_screen.dart';
import 'package:bonga_music/theme.dart';
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
  List<int> albumNo = [];
  @override
  void initState() {
    getArtistData();
    super.initState();
  }

  //get artist data
  void getArtistData() {
    List<String> newArtists = [];
    ref.read(musicFilePathMetadataProvider).forEach((element) {
      artists.add(element.values.first?.albumArtist ?? "Unknown");
    });
    setState(() => newArtists = artists.toSet().toList());
    setState(() => artists = newArtists);
    debugPrint("==============Get Artists Data============${artists.length}");
  }

  //get artist albums
  int getArtistAlbums(String albumArtist) {
    List<String> newAlbums = [];
    ref.read(musicFilePathMetadataProvider).forEach((element) {
      if (element.values.first?.albumArtist == albumArtist) {
        albums.add(element.values.first!.album!);
      }
    });
    newAlbums = albums.toSet().toList();
    return newAlbums.length;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
      child: artists.isNotEmpty
          ? GridView.builder(
              itemCount: artists.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) => _AlbumWidget(
                artist: artists[index],
                songsNo: artists[index] != "Unknown"
                    ? ref
                        .read(musicFilePathMetadataProvider)
                        .where((element) =>
                            element.values.first?.albumArtist == artists[index])
                        .length
                    : ref
                        .read(musicFilePathMetadataProvider)
                        .where((element) => element.values.first == null)
                        .length,
                number: index,
              ),
            )
          : const Center(
              child: Text("Artists Page"),
            ),
    ));
  }
}

class _AlbumWidget extends ConsumerWidget {
  const _AlbumWidget(
      {required this.artist, required this.songsNo, required this.number});
  final String artist;
  final int songsNo;
  final int number;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        List<String> musicFiles = [];
        ref
            .read(musicFilePathMetadataProvider)
            .where((element) => element.values.first?.albumArtist == artist)
            .forEach((element) {
          musicFiles.add(element.keys.first);
        });
        ref
            .read(currentMusicFilePathsProvider.notifier)
            .update((state) => musicFiles);
        debugPrint("====Music Files======${musicFiles.length}");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ArtistWorksScreen(),
            ));
      },
      child: Card(
        color: number.isEven ? AppColors.accent : AppColors.secondary,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                artist,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(
                height: 5,
              ),
              Text("Songs : $songsNo")
            ]),
      ),
    );
  }
}
