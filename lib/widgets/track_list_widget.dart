import 'package:bonga_music/api/music_player_logic_operations.dart';
import 'package:bonga_music/models/single_track_enum.dart';
import 'package:bonga_music/repositories/music_File_Paths_Provider.dart';
import 'package:bonga_music/widgets/single_track_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';

class TrackList extends ConsumerStatefulWidget {
  const TrackList(
      {super.key,
      required this.musicFilePaths,
      required this.playerState,
      required this.singleTrackEnum});
  final List<String> musicFilePaths;
  final ValueNotifier<bool> playerState;
  final SingleTrackEnum singleTrackEnum;

  @override
  ConsumerState<TrackList> createState() => _TrackListState();
}

class _TrackListState extends ConsumerState<TrackList> {
  List<Metadata?> songMetatdata = [];
  List<String> sortedMusicFilePaths = [];
  List<Metadata?> sortedMetadata = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sortMusicList();
    debugPrint(
        '========+++++${widget.musicFilePaths.length}=======+++++++++++');
  }

  void sortMusicList() async {
    var no = 0;
    List<Metadata?> temporarySorter = [];
    for (var file in widget.musicFilePaths) {
      await MusicAPI()
          .getMusicMetaData(file)
          .then((value) => setState(() => songMetatdata.add(value)));
    }
    for (int i = 0; i <= widget.musicFilePaths.length - 1; i++) {
      no = songMetatdata.indexWhere((element) => element?.trackNumber == i + 1);
      if (!no.isNegative) {
        setState(() {
          sortedMusicFilePaths.add(widget.musicFilePaths[no]);
          sortedMetadata.add(songMetatdata[no]);
        });
      }
    }

    if (no.isNegative) {
      for (var file in widget.musicFilePaths) {
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
        debugPrint(
            '........${data!.title}...................${data.trackNumber}===================');
        setState(() {
          sortedMusicFilePaths.add(widget.musicFilePaths[songMetatdata
              .indexWhere((element) => element!.title == data.title)]);
          sortedMetadata.add(songMetatdata[songMetatdata
              .indexWhere((element) => element!.title == data.title)]);
        });
      }
    }
    //Updating State to current sorted music file paths
    ref
        .read(currentMusicFilePathsProvider.notifier)
        .update((state) => sortedMusicFilePaths);
    //Updating State to current sorted music file paths metadata
    ref
        .read(currentFilePathsMetadataProvider.notifier)
        .update((state) => sortedMetadata);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ref.read(currentMusicFilePathsProvider).length,
      itemBuilder: (context, index) {
        return SingleTrack(
          // currentTrack: widget.currentTrack,
          myTrackPath: ref.read(currentMusicFilePathsProvider)[index],
          trackTitle:
              ref.read(currentFilePathsMetadataProvider)[index]?.title ??
                  "Unknown",
          trackArtist:
              ref.read(currentFilePathsMetadataProvider)[index]?.artist ??
                  "Unknown",
          musicFiles: sortedMusicFilePaths,
          singleTrackEnum: widget.singleTrackEnum,
          tracksCount: null,
        );
      },
    );
  }
}
