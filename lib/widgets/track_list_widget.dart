import 'package:bonga_music/models/single_track_enum.dart';
import 'package:bonga_music/repositories/musicFilePathsProvider.dart';
import 'package:bonga_music/widgets/single_track_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrackList extends ConsumerWidget {
  const TrackList({super.key, required this.singleTrackEnum});
  final SingleTrackEnum singleTrackEnum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: ref.watch(currentMusicFilePathsProvider).length,
      itemBuilder: (context, index) {
        return SingleTrack(
          // currentTrack: widget.currentTrack,
          myTrackPath: ref.watch(currentMusicFilePathsProvider)[index],

          singleTrackEnum: singleTrackEnum,
        );
      },
    );
  }
}
