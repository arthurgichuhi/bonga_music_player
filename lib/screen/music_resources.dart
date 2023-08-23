import 'package:audioplayers/audioplayers.dart';
import 'package:bonga_music/api/music_player_logic_operations.dart';
import 'package:bonga_music/database/db_api/db_operations_api.dart';
import 'package:bonga_music/pages/albums.dart';
import 'package:bonga_music/widgets/music_resources_navigation_button.dart';
import 'package:bonga_music/widgets/player_widget.dart';
import 'package:flutter/material.dart';

import '../pages/playlists.dart';

final audioPlayer = AudioPlayer();
ValueNotifier<String> currentTrackPath = ValueNotifier('');
ValueNotifier<int> loopStatus = ValueNotifier(0);
ValueNotifier<List<String>> trackFilePaths = ValueNotifier([]);
ValueNotifier<int> playListId = ValueNotifier(0);

//this is the main application widget
class MusicResources extends StatefulWidget {
  const MusicResources({super.key});

  @override
  State<MusicResources> createState() => _MusicResourcesState();
}

class _MusicResourcesState extends State<MusicResources> {
  final ValueNotifier<int> pageIndex = ValueNotifier(0);
  final pages = [const AlbumsList(), const PlayListsWidget()];
  List<String> musicFiles = [];
  @override
  void initState() {
    super.initState();
    //check database for saved music file paths
    IsarDBServices().getSavedMusicFiles().then((value) {
      if (value.isEmpty) {
        MusicAPI().getLocalMusicFiles().then((value) async {
          await IsarDBServices().getSavedMusicFiles().then((value) =>
              setState(() => musicFiles = value[0].musicFilePaths ?? []));
        });
      }
      setState(() {
        musicFiles = value[0].musicFilePaths ?? [];
        currentTrackPath.value = musicFiles[0];
      });
    });
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
            musicFiles.isNotEmpty
                ? Player(
                    musicFiles: musicFiles,
                    screen: null,
                    currentTrack: currentTrackPath,
                    playerState: ValueNotifier(false),
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
