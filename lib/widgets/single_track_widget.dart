import 'package:audioplayers/audioplayers.dart';
import 'package:bonga_music/database/db_api/db_operations_api.dart';
import 'package:bonga_music/database/playlists/playlist.dart';
import 'package:bonga_music/repositories/music_File_Paths_Provider.dart';
import 'package:bonga_music/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/single_track_enum.dart';

class SingleTrack extends ConsumerStatefulWidget {
  const SingleTrack({
    super.key,
    required this.myTrackPath,
    required this.singleTrackEnum,
  });
  final String myTrackPath;
  final SingleTrackEnum singleTrackEnum;

  @override
  ConsumerState<SingleTrack> createState() => _SingleTrackState();
}

class _SingleTrackState extends ConsumerState<SingleTrack> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          //Updating current music track
          ref
              .read(currentTrackProvider.notifier)
              .update((state) => widget.myTrackPath);
          //Updating play state bool
          ref.read(playerStateProvider.notifier).update((state) => true);
          //triggler play
          ref
              .read(audioPlayerProvider)
              .play(UrlSource(ref.read(currentTrackProvider)));
        },
        child: SizedBox(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  minHeight: MediaQuery.of(context).size.height * .055),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ref
                            .read(musicFilePathMetadataProvider)
                            .where((element) =>
                                element.keys.first == widget.myTrackPath)
                            .first
                            .values
                            .first
                            ?.title ??
                        "Unknown",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: ref.watch(currentTrackProvider) ==
                                widget.myTrackPath
                            ? AppColors.accent
                            : null),
                  ),
                  Text(
                    ref
                            .watch(musicFilePathMetadataProvider)
                            .where((element) =>
                                element.keys.first == widget.myTrackPath)
                            .first
                            .values
                            .first
                            ?.artist ??
                        "Unknown",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: ref.watch(currentTrackProvider) ==
                                widget.myTrackPath
                            ? AppColors.accent
                            : null),
                  )
                ],
              ),
            ),
            widget.singleTrackEnum == SingleTrackEnum.playlist
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

//this function removes a song from the play list and updates playlists data in state and database
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
              if (track != widget.myTrackPath) {
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
              ref.read(currentMusicFilePathsProvider.notifier).update((state) =>
                  ref
                      .read(playListsProvider)
                      .where((element) => element.id == ref.read(playListIdDb))
                      .first
                      .play_list_songs!);
            });
          })
        : debugPrint("======================Null Id======================");
  }
}
