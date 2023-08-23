import 'package:bonga_music/database/db_api/db_operations_api.dart';
import 'package:bonga_music/database/playlists/playlist.dart';
import 'package:flutter/material.dart';

class PlayListSetButton extends StatelessWidget {
  const PlayListSetButton(
      {super.key, required this.playLists, required this.trackPaths});
  final PlayLists playLists;
  final List<String> trackPaths;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () async {
          List<String> newPlayListTracks = [];
          for (var track in playLists.play_list_songs!) {
            newPlayListTracks.add(track);
          }
          for (var track in trackPaths) {
            playLists.play_list_songs!
                    .where((element) => track == element)
                    .isEmpty
                ? newPlayListTracks.add(track)
                : null;
          }
          PlayLists newPlayLists = PlayLists();
          newPlayLists.id = playLists.id;
          newPlayLists.playListName = playLists.playListName;
          newPlayLists.play_list_songs = newPlayListTracks;

          await IsarDBServices()
              .savePlayListData(playLists: newPlayLists)
              .then((value) {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(playLists.playListName!),
            Text('${playLists.play_list_songs?.length}')
          ],
        ),
      ),
    );
  }
}
