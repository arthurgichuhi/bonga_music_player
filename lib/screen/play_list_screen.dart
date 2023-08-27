import 'package:bonga_music/database/playlists/playlist.dart';
import 'package:bonga_music/models/single_track_enum.dart';
import 'package:bonga_music/repositories/music_File_Paths_Provider.dart';
import 'package:bonga_music/widgets/player_widget.dart';
import 'package:bonga_music/widgets/single_track_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayListsScreen extends ConsumerStatefulWidget {
  const PlayListsScreen({super.key, required this.playListData});
  final PlayLists playListData;

  @override
  ConsumerState<PlayListsScreen> createState() => _PlayListsScreenState();
}

class _PlayListsScreenState extends ConsumerState<PlayListsScreen> {
  ValueNotifier<int> playListTrackNo = ValueNotifier(0);
  List<String> musicFilePaths = [];
  @override
  void initState() {
    //Update music file paths variable to currentMusicFilePaths state
    setState(() => musicFilePaths = ref.read(currentMusicFilePathsProvider));
    //begin process of listening and updating musicFilePaths variable when
    //currentMusicFilePathsProvider changes
    ref.listen(currentMusicFilePathsProvider,
        (previous, next) => setState(() => musicFilePaths = next));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.playListData.playListName}'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ref.read(currentMusicFilePathsProvider).isNotEmpty
                  ? ListView.builder(
                      itemCount: musicFilePaths.length,
                      itemBuilder: (context, index) => SingleTrack(
                        myTrackPath: musicFilePaths[index],
                        singleTrackEnum: SingleTrackEnum.playlist,
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            const Player(
              screen: null,
            )
          ],
        ));
  }
}
