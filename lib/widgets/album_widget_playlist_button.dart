import 'package:flutter/material.dart';

import '../database/db_api/db_operations_api.dart';
import '../database/playlists/playlist.dart';
import '../theme.dart';

class AlbumWidgetPlayListButton extends StatelessWidget {
  const AlbumWidgetPlayListButton(
      {super.key, required this.songs, required this.playlists});
  final List<String> songs;
  final List<PlayLists> playlists;

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();
    return IconButton(
        onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                  elevation: 10,
                  backgroundColor: AppColors.cardDark,
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        TextButton(
                            onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: ListBody(children: [
                                      if (playlists.isNotEmpty) ...[
                                        ListView.builder(
                                          itemCount: playlists.length,
                                          itemBuilder: (context, index) => Text(
                                              playlists[index].playListName!),
                                        ),
                                        const Divider(
                                          height: 1,
                                        ),
                                      ],
                                      TextField(
                                        controller: controller,
                                        decoration: const InputDecoration(
                                            hintText: 'Playlist Name'),
                                      ),
                                      Row(
                                        children: [
                                          TextButton(
                                              onPressed: () {},
                                              child: Text('Cancel')),
                                          TextButton(
                                              onPressed: () {
                                                PlayLists playLists =
                                                    PlayLists();
                                                playLists.id = DateTime.now()
                                                    .millisecondsSinceEpoch;
                                                playLists.play_list_songs =
                                                    songs;
                                                IsarDBServices()
                                                    .savePlayListData(
                                                        playLists: playLists);
                                              },
                                              child: Text('Save'))
                                        ],
                                      )
                                    ]),
                                  ),
                                ),
                            child: const Text(
                              'Create New Play List',
                              style: TextStyle(color: AppColors.textlight),
                            )),
                        TextButton(
                            onPressed: () {},
                            child: const Text('Add To Play List',
                                style: TextStyle(color: AppColors.textlight)))
                      ],
                    ),
                  )),
            ),
        icon: Icon(Icons.library_add));
  }
}
