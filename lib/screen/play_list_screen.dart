import 'package:bonga_music/api/music_player_logic_operations.dart';
import 'package:bonga_music/database/db_api/db_operations_api.dart';
import 'package:bonga_music/database/playlists/playlist.dart';
import 'package:bonga_music/models/single_track_enum.dart';
import 'package:bonga_music/widgets/player_widget.dart';
import 'package:bonga_music/widgets/single_track_widget.dart';
import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';

class PlayListsScreen extends StatefulWidget {
  const PlayListsScreen(
      {super.key, required this.playListData, required this.musicFilesNo});
  final PlayLists playListData;
  final ValueChanged<int> musicFilesNo;
  @override
  State<PlayListsScreen> createState() => _PlayListsScreenState();
}

class _PlayListsScreenState extends State<PlayListsScreen> {
  //listen to changes of player widget play state
  // ValueNotifier<bool> playerState = ValueNotifier(false);
  //listen to changes in number of playlist tracks
  ValueNotifier<int> playListTrackNo = ValueNotifier(0);
  Stream<PlayLists?>? playListStreamData;
  PlayLists? playLists;
  List<Metadata?> musicMetadata = [];
  List<String> musicFiles = [];
  @override
  void initState() {
    debugPrint("+++++++++++++++++++++Rebuilding+++++++++++++++++++++++++");
    IsarDBServices()
        .getPlayListData(widget.playListData.id)
        .then((value) => setState(() => musicFiles = value!.play_list_songs!))
        .then((value) => getMusicMetadata(musicFiles: musicFiles));

    super.initState();
  }

  getMusicMetadata({required List<String> musicFiles}) async {
    for (var file in musicFiles) {
      MusicAPI()
          .getMusicMetaData(file)
          .then((value) => setState(() => musicMetadata.add(value)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.playListData.playListName}'),
          centerTitle: true,
        ),
        body: ValueListenableBuilder(
          valueListenable: playListTrackNo,
          builder: (context, value, _) {
            return Column(
              children: [
                Expanded(
                  child: musicFiles.isNotEmpty &&
                          musicMetadata.isNotEmpty &&
                          musicMetadata.length == musicFiles.length
                      ? StreamBuilder(
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                itemCount: musicFiles.length,
                                itemBuilder: (context, index) => SingleTrack(
                                  myTrackPath: widget
                                      .playListData.play_list_songs![index],
                                  trackTitle:
                                      musicMetadata[index]?.title ?? "Unknown",
                                  trackArtist:
                                      musicMetadata[index]?.artist ?? "Unknown",
                                  musicFiles:
                                      widget.playListData.play_list_songs!,
                                  singleTrackEnum: SingleTrackEnum.playlist,
                                  tracksCount: (value) {
                                    playListTrackNo.value = value;
                                    widget.musicFilesNo.call(value);
                                    setState(() {});
                                  },
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text('Empty'),
                              );
                            }
                          },
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
                const Player(
                  screen: null,
                )
              ],
            );
          },
        ));
  }
}
