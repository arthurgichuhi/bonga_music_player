import 'package:audioplayers/audioplayers.dart';
import 'package:bonga_music/database/db_api/db_operations_api.dart';
import 'package:bonga_music/database/playlists/playlist.dart';
import 'package:bonga_music/repositories/musicFilePathsProvider.dart';
import 'package:bonga_music/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/single_track_enum.dart';

class SingleTrack extends ConsumerWidget {
  const SingleTrack({
    super.key,
    required this.myTrackPath,
    required this.singleTrackEnum,
  });
  final String myTrackPath;
  final SingleTrackEnum singleTrackEnum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //this function removes a song from the play list
    // and updates playlists data in state and database
    void remove() async {
      ref.read(playListIdDb) != null
          ? await IsarDBServices()
              .getPlayListData(ref.read(playListIdDb)!)
              .then((value) async {
              List<String> newTrackList = [];
              PlayLists playLists = PlayLists();
              playLists.id = value!.id;
              playLists.playListName = value.playListName;
              for (var track in value.play_list_songs!) {
                if (track != myTrackPath) {
                  newTrackList.add(track);
                }
              }
              //updating current music file paths provider
              ref
                  .read(currentMusicFilePathsProvider.notifier)
                  .update((state) => newTrackList);
              playLists.play_list_songs = newTrackList;
              var currentPlayListState = ref.read(playListsProvider);
              for (var playlist in currentPlayListState) {
                if (playlist.id == ref.read(playListIdDb)) {
                  playlist = playLists;
                }
              }
              await IsarDBServices().savePlayListData(playLists: playLists);
              await IsarDBServices().getListOfPlaylists().then((value) {
                //updating playlist state
                ref.read(playListsProvider.notifier).update((state) => value);
                //updating current Music File Paths provider state
                ref.read(currentMusicFilePathsProvider.notifier).update(
                    (state) => ref
                        .read(playListsProvider)
                        .where(
                            (element) => element.id == ref.read(playListIdDb))
                        .first
                        .play_list_songs!);
              });
            })
          : debugPrint("======================Null Id======================");
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          //Updating current music track
          ref
              .read(currentTrackProvider.notifier)
              .update((state) => myTrackPath);
          //Updating play state bool
          ref.read(playerStateProvider.notifier).update((state) => true);
          ref.read(audioPlayerProvider).state == PlayerState.playing
              ? null
              : await ref
                  .read(audioPlayerProvider)
                  .play(UrlSource(ref.read(currentTrackProvider)));
        },
        child: SizedBox(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .8,
                  minHeight: MediaQuery.of(context).size.height * .055),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      ref
                              .read(musicFilePathMetadataProvider)
                              .where((element) =>
                                  element.keys.first == myTrackPath)
                              .first
                              .values
                              .first
                              ?.title ??
                          "Unknown",
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: ref.read(currentTrackProvider) == myTrackPath
                              ? AppColors.accent
                              : null),
                    ),
                  ),
                  Text(
                    ref
                            .read(musicFilePathMetadataProvider)
                            .where(
                                (element) => element.keys.first == myTrackPath)
                            .first
                            .values
                            .first
                            ?.artist ??
                        "Unknown",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: ref.watch(currentTrackProvider) == myTrackPath
                            ? AppColors.accent
                            : null),
                  )
                ],
              ),
            ),
            singleTrackEnum == SingleTrackEnum.playlist
                ? PopupMenuButton(
                    itemBuilder: (context) => <PopupMenuEntry>[
                          PopupMenuItem(
                            child: const Text('Edit Tags'),
                            onTap: () {},
                          ),
                          PopupMenuItem(
                            child: const Text('Remove'),
                            onTap: () => remove(),
                          )
                        ])
                : const SizedBox()
          ]),
        ),
      ),
    );
  }
}
