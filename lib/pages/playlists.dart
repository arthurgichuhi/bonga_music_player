import 'package:bonga_music/database/db_api/db_operations_api.dart';
import 'package:bonga_music/screen/music_resources.dart';
import 'package:bonga_music/screen/play_list_screen.dart';
import 'package:flutter/material.dart';

import '../database/playlists/playlist.dart';

class PlayListsWidget extends StatefulWidget {
  const PlayListsWidget({super.key});

  @override
  State<PlayListsWidget> createState() => _PlayListsWidgetState();
}

class _PlayListsWidgetState extends State<PlayListsWidget> {
  List<PlayLists> playlistData = [];

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
    return Expanded(
        child: playlistData.isNotEmpty
            ? ListView.builder(
                itemCount: playlistData.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) => Card(
                  child: InkWell(
                    onTap: () {
                      playListId.value = playlistData[index].id;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayListsScreen(
                                playListData: playlistData[index]),
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
                ),
              )
            : const Text('No PlayListsWidget Created'));
  }
}
