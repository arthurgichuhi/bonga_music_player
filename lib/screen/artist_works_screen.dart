import 'package:bonga_music/models/single_track_enum.dart';
import 'package:bonga_music/widgets/player_widget.dart';
import 'package:bonga_music/widgets/track_list_widget.dart';
import 'package:flutter/material.dart';

class ArtistWorksScreen extends StatefulWidget {
  const ArtistWorksScreen({super.key});

  @override
  State<ArtistWorksScreen> createState() => _ArtistWorksScreenState();
}

class _ArtistWorksScreenState extends State<ArtistWorksScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Expanded(child: TrackList(singleTrackEnum: SingleTrackEnum.album)),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Player(screen: null),
          )
        ],
      ),
    );
  }
}

class ArtistAlbums extends StatelessWidget {
  const ArtistAlbums({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ArtistSongs extends StatelessWidget {
  const ArtistSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
