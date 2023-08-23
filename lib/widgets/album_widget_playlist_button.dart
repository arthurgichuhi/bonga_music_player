import 'package:bonga_music/widgets/playlist_sets_widget.dart';
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
                    child: Column(
                      children: [
                        TextButton(
                            onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(minHeight: 50),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            FutureBuilder<List<PlayLists>>(
                                              future: IsarDBServices()
                                                  .getListOfPlaylists(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return ListView.builder(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        snapshot.data!.length,
                                                    itemBuilder: (context,
                                                            index) =>
                                                        PlayListSetButton(
                                                            playLists: snapshot
                                                                .data![index],
                                                            trackPaths: songs),
                                                  );
                                                } else {
                                                  return const Center(
                                                    child: Text(
                                                        'No Playlists Created'),
                                                  );
                                                }
                                              },
                                            ),
                                            const Divider(
                                              height: 5,
                                            ),
                                            TextField(
                                              controller: controller,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                    left: 5,
                                                  ),
                                                  hintText: 'Playlist Name'),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .textlight),
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      PlayLists playLists =
                                                          PlayLists();
                                                      playLists.id = DateTime
                                                              .now()
                                                          .millisecondsSinceEpoch;
                                                      playLists
                                                              .play_list_songs =
                                                          songs;
                                                      playLists.playListName =
                                                          controller.text;
                                                      IsarDBServices()
                                                          .savePlayListData(
                                                              playLists:
                                                                  playLists)
                                                          .then((value) =>
                                                              Navigator.pop(
                                                                  context));
                                                    },
                                                    child: const Text(
                                                      'Save',
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .textlight),
                                                    ))
                                              ],
                                            )
                                          ]),
                                    ),
                                  ),
                                ),
                            child: const Text(
                              'Add Playlist',
                              style: TextStyle(color: AppColors.textlight),
                            )),
                      ],
                    ),
                  )),
            ),
        icon: Icon(Icons.library_add));
  }
}
