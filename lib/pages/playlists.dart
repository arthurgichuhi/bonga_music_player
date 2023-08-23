import 'package:bonga_music/database/db_api/db_operations_api.dart';
import 'package:bonga_music/repositories/music_File_Paths_Provider.dart';
import 'package:bonga_music/screen/play_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/playlists/playlist.dart';

class PlayListsWidget extends ConsumerStatefulWidget {
  const PlayListsWidget({super.key});

  @override
  ConsumerState<PlayListsWidget> createState() => _PlayListsWidgetState();
}

class _PlayListsWidgetState extends ConsumerState<PlayListsWidget> {
  List<PlayLists> playlistData = [];
  ValueNotifier<int> musicTracksNo = ValueNotifier(0);
  @override
  void initState() {
    getPlayListData();
    super.initState();
  }

//getting created playlists data from the database
  void getPlayListData() async {
    await IsarDBServices()
        .getListOfPlaylists()
        .then((value) => setState(() => playlistData = value));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: playlistData.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) => Card(
              child: InkWell(
                onTap: () {
                  ref
                      .read(playListIdDb.notifier)
                      .update((state) => playlistData[index].id);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayListsScreen(
                          playListData: playlistData[index],
                          musicFilesNo: (value) {
                            musicTracksNo.value = value;
                            setState(() {});
                          },
                        ),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(playlistData[index].playListName!),
                      Text(
                          'Tracks:${playlistData[index].play_list_songs!.length}')
                    ],
                  ),
                ),
              ),
            ));
  }
}
