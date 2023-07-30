import 'package:bonga_music/api/songs.dart';
import 'package:bonga_music/widgets/single_track_widget.dart';
import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';

class TrackList extends StatefulWidget {
  const TrackList(
      {super.key,
      required this.musicFilePaths,
      required this.musicTitles,
      required this.trackArtists,
      required this.trackDuration,
      required this.currentTrack,
      required this.playerState});
  final List<String> musicFilePaths;
  final List<String?> musicTitles;
  final List<String> trackArtists;
  final List<double?> trackDuration;
  final ValueNotifier<String> currentTrack;
  final ValueNotifier<bool> playerState;

  @override
  State<TrackList> createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
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
      temporarySorter.sort((a, b) {
        int aTrack = a!.trackNumber!;
        int bTrack = b!.trackNumber!;
        return aTrack.compareTo(bTrack);
      });
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
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.currentTrack,
      builder: (context, value, _) {
        return ListView.builder(
          itemCount: sortedMusicFilePaths.length,
          itemBuilder: (context, index) {
            return SingleTrack(
              currentTrack: widget.currentTrack,
              myTrackPath: sortedMusicFilePaths[index],
              trackTitle: sortedMetadata[index]!.title!,
              trackArtist: sortedMetadata[index]!.artist!,
              playerState: widget.playerState,
              musicFiles: sortedMusicFilePaths,
            );
          },
        );
      },
    );
  }
}
