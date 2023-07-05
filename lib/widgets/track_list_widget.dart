import 'package:bonga_music/widgets/single_track_widget.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.currentTrack,
      builder: (context, value, _) {
        return ListView.builder(
          itemCount: widget.musicFilePaths.length,
          itemBuilder: (context, index) {
            return SingleTrack(
              currentTrack: widget.currentTrack,
              myTrackPath: widget.musicFilePaths[index],
              trackTitle: widget.musicTitles[index]!,
              trackArtist: widget.trackArtists[index],
              playerState: widget.playerState,
            );
          },
        );
      },
    );
  }
}
