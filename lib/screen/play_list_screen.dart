import 'package:bonga_music/database/db_api/db_operations_api.dart';
import 'package:flutter/material.dart';

import '../database/playlists/playlist.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({super.key});

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlayLists>>(
        future: IsarDBServices().getListOfPlaylists(),
        builder: (context, snapshot) {
          var playLists = snapshot.data;
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(playLists![index].playListName!),
                  Text('Tracks:${playLists.length}')
                ],
              ),
            );
          } else {
            return const Text('No PlayLists Created');
          }
        });
  }
}
