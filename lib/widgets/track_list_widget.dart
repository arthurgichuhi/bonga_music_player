import 'package:bonga_music/api/music_player_logic_operations.dart';
import 'package:bonga_music/models/single_track_enum.dart';
import 'package:bonga_music/repositories/music_File_Paths_Provider.dart';
import 'package:bonga_music/widgets/single_track_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';

class TrackList extends ConsumerStatefulWidget {
  const TrackList({super.key, required this.singleTrackEnum});
  final SingleTrackEnum singleTrackEnum;

  @override
  ConsumerState<TrackList> createState() => _TrackListState();
}

class _TrackListState extends ConsumerState<TrackList> {
  List<Metadata?> songMetatdata = [];
  List<String> sortedMusicFilePaths = [];
  // List<Metadata?> sortedMetadata = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sortMusicList();
  }

  void sortMusicList() async {
    var no = 0;
    List<Metadata?> temporarySorter = [];
    for (var file in ref.read(currentMusicFilePathsProvider)) {
      await MusicAPI()
          .getMusicMetaData(file)
          .then((value) => setState(() => songMetatdata.add(value)));
    }
    for (int i = 0;
        i <= ref.read(currentMusicFilePathsProvider).length - 1;
        i++) {
      no = songMetatdata.indexWhere((element) => element?.trackNumber == i + 1);
      if (!no.isNegative) {
        setState(() {
          sortedMusicFilePaths.add(ref.read(currentMusicFilePathsProvider)[no]);
        });
      }
    }

    if (no.isNegative) {
      for (var file in ref.read(currentMusicFilePathsProvider)) {
        await MusicAPI()
            .getMusicMetaData(file)
            .then((value) => temporarySorter.add(value));
      }
      // if (widget.singleTrackEnum != SingleTrackEnum.playlist) {
      temporarySorter.sort((a, b) {
        int aTrack = a!.trackNumber!;
        int bTrack = b!.trackNumber!;
        return aTrack.compareTo(bTrack);
      });
      // }
      for (var data in temporarySorter) {
        setState(() {
          sortedMusicFilePaths.add(ref.read(currentMusicFilePathsProvider)[
              songMetatdata
                  .indexWhere((element) => element!.title == data!.title)]);
        });
      }
    }
    sortedMusicFilePaths.toSet().toList();
    //Updating State to current sorted music file paths
    ref
        .read(currentMusicFilePathsProvider.notifier)
        .update((state) => sortedMusicFilePaths);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ref.watch(currentMusicFilePathsProvider).length,
      itemBuilder: (context, index) {
        return SingleTrack(
          // currentTrack: widget.currentTrack,
          myTrackPath: ref.read(currentMusicFilePathsProvider)[index],

          singleTrackEnum: widget.singleTrackEnum,
        );
      },
    );
  }
}
