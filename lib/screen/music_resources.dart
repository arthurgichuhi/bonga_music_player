import 'package:audioplayers/audioplayers.dart';
import 'package:bonga_music/pages/albums.dart';
import 'package:bonga_music/widgets/music_resources_navigation_button.dart';
import 'package:bonga_music/widgets/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/playlists.dart';
import '../repositories/music_File_Paths_Provider.dart';

final audioPlayer = AudioPlayer();

//this is the main application widget
class MusicResources extends ConsumerStatefulWidget {
  const MusicResources({super.key});

  @override
  ConsumerState<MusicResources> createState() => _MusicResourcesState();
}

class _MusicResourcesState extends ConsumerState<MusicResources> {
  final ValueNotifier<int> pageIndex = ValueNotifier(0);
  final pages = [const AlbumsList(), const PlayListsWidget()];
  List<String> musicFiles = [];
  @override
  void initState() {
    super.initState();
    setState(() => musicFiles = ref.read(allMusicTrackProvider));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
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
            ref.read(allMusicTrackProvider).isNotEmpty
                ? const Player(
                    screen: null,
                  )
                : const Center(
                    child: Text("No music files available"),
                  )
          ],
        ),
      ),
    );
  }
}
