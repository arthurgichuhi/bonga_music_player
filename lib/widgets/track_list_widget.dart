import 'package:flutter/material.dart';

class TrackList extends StatefulWidget {
  const TrackList(
      {super.key,
      required this.musicFilePaths,
      required this.musicTitles,
      required this.trackDuration});
  final List<String> musicFilePaths;
  final List<String?> musicTitles;
  final List<double?> trackDuration;

  @override
  State<TrackList> createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
