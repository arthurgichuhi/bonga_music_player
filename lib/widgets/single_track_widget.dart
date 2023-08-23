import 'package:bonga_music/database/db_api/db_operations_api.dart';
import 'package:bonga_music/database/playlists/playlist.dart';
import 'package:bonga_music/repositories/music_File_Paths_Provider.dart';
import 'package:bonga_music/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/single_track_enum.dart';

class SingleTrack extends ConsumerStatefulWidget {
  const SingleTrack(
      {super.key,
      required this.myTrackPath,
      required this.trackTitle,
      required this.trackArtist,
      required this.musicFiles,
      required this.singleTrackEnum,
      required this.tracksCount});
  final String myTrackPath;
  final String trackTitle;
  final String trackArtist;
  final List<String> musicFiles;
  final SingleTrackEnum singleTrackEnum;
  final ValueChanged<int>? tracksCount;

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
          //Updating all File paths of selected playlist or album
          ref
              .read(currentMusicFilePathsProvider.notifier)
              .update((state) => widget.musicFiles);
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
                    widget.trackTitle,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color:
                            ref.read(currentTrackProvider) == widget.myTrackPath
                                ? AppColors.accent
                                : null),
                  ),
                  Text(widget.trackArtist)
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
                            onTap: () async {
                              await IsarDBServices()
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
                                playLists.play_list_songs = newTrackList;
                                await IsarDBServices()
                                    .savePlayListData(playLists: playLists);
                                widget.tracksCount?.call(newTrackList.length);
                              });
                            },
                          )
                        ])
                : const SizedBox()
          ]),
        ),
      ),
    );
  }
}
