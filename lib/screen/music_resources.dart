import 'package:bonga_music/api/songs.dart';
import 'package:bonga_music/pages/albums.dart';
import 'package:bonga_music/theme.dart';
import 'package:bonga_music/widgets/music_resources_navigation_button.dart';
import 'package:bonga_music/widgets/player_widget.dart';
import 'package:flutter/material.dart';

class MusicResources extends StatefulWidget {
  const MusicResources({super.key});

  @override
  State<MusicResources> createState() => _MusicResourcesState();
}

class _MusicResourcesState extends State<MusicResources> {
  final ValueNotifier<int> pageIndex = ValueNotifier(0);
  final pages = [const AlbumsList()];
  List<String> musicFiles = [];
  List<dynamic> musicAlbums = [];
  @override
  void initState() {
    super.initState();
    MusicAPI().getLocalMusicFiles().then((value) {
      setState(() {
        musicFiles = value;
      });
      MusicAPI().getMusicAlbums(musicFiles).then((value) {
        setState(() {
          musicAlbums = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bonga Music Player'),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ResourcesNavigation(
                      button_name: 'Albums',
                      on_pressed: () {
                        if (pageIndex.value != 0) {
                          pageIndex.value = 0;
                        }
                      }),
                  ResourcesNavigation(
                      button_name: 'PlayLists',
                      on_pressed: () {
                        if (pageIndex.value != 1) {
                          pageIndex.value = 1;
                        }
                      }),
                  ResourcesNavigation(
                      button_name: 'Artists',
                      on_pressed: () {
                        if (pageIndex.value != 2) {
                          pageIndex.value = 2;
                        }
                      }),
                  ResourcesNavigation(
                      button_name: 'Songs',
                      on_pressed: () {
                        if (pageIndex.value != 3) {
                          pageIndex.value = 3;
                        }
                      })
                ],
              ),
            ),
            ValueListenableBuilder(
              valueListenable: pageIndex,
              builder: (context, value, _) {
                return pages[value];
              },
            ),
            musicFiles.isNotEmpty
                ? Player(
                    musicFiles: musicFiles,
                    screen: null,
                    currentTrack: ValueNotifier(''),
                    playerState: ValueNotifier(false),
                  )
                : const CircularProgressIndicator(
                    color: AppColors.accent,
                  )
          ],
        ),
      ),
    );
  }
}
