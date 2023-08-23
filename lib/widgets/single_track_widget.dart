import 'package:bonga_music/database/db_api/db_operations_api.dart';
import 'package:bonga_music/database/playlists/playlist.dart';
import 'package:bonga_music/theme.dart';
import 'package:flutter/material.dart';
import '../models/single_track_enum.dart';
import '../screen/music_resources.dart';

class SingleTrack extends StatefulWidget {
  const SingleTrack(
      {super.key,
      required this.currentTrack,
      required this.playerState,
      required this.myTrackPath,
      required this.trackTitle,
      required this.trackArtist,
      required this.musicFiles,
      required this.singleTrackEnum,
      required this.callBack});
  final ValueNotifier<String> currentTrack;
  final ValueNotifier<bool> playerState;
  final String myTrackPath;
  final String trackTitle;
  final String trackArtist;
  final List<String> musicFiles;
  final SingleTrackEnum singleTrackEnum;
  final List<VoidCallback> callBack;

  @override
  State<SingleTrack> createState() => _SingleTrackState();
}

class _SingleTrackState extends State<SingleTrack> {
  // ValueNotifier<String> currentTrack = ValueNotifier('');
  @override
  void initState() {
    valueChangeListener();
    super.initState();

    // valueChangeListener();
  }

  valueChangeListener() {
    currentTrackPath.addListener(() {
      debugPrint(
          'single track .........................${widget.currentTrack.value}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          widget.currentTrack.value = widget.myTrackPath;
          widget.playerState.value = true;
          trackFilePaths.value = widget.musicFiles;
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
                        color: currentTrackPath.value == widget.myTrackPath
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
                                  .getPlayListData(playListId.value)
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
                                widget.callBack[0];
                              });
                            },
                          )
                        ])
                : SizedBox()
          ]),
        ),
      ),
    );
  }
}
