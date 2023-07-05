import 'dart:typed_data';

import 'package:bonga_music/widgets/player_widget.dart';
import 'package:bonga_music/widgets/track_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlbumViewScreen extends StatefulWidget {
  const AlbumViewScreen(
      {super.key,
      required this.albumArt,
      required this.albumName,
      required this.albumArtist,
      required this.songs,
      required this.duration,
      required this.musicTitle,
      required this.trackArtists});
  final Uint8List albumArt;
  final String albumName;
  final String albumArtist;
  final List<String> songs;
  final List<double?> duration;
  final List<String> musicTitle;
  final List<String> trackArtists;

  @override
  State<AlbumViewScreen> createState() => _AlbumViewScreenState();
}

class _AlbumViewScreenState extends State<AlbumViewScreen> {
  ValueNotifier<String> currentTrack = ValueNotifier('');
  ValueNotifier<bool> playerState = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Card(
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.20,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.height * 0.20,
                          child: Image.memory(
                            widget.albumArt,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, top: 46),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 200, child: Text(widget.albumName)),
                              const Divider(
                                height: 1,
                              ),
                              Text(widget.albumArtist),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )),
          ),
          Expanded(
              child: TrackList(
            musicFilePaths: widget.songs,
            musicTitles: widget.musicTitle,
            trackArtists: widget.trackArtists,
            trackDuration: widget.duration,
            currentTrack: currentTrack,
            playerState: playerState,
          )),
          Player(
            musicFiles: widget.songs,
            screen: null,
            currentTrack: currentTrack,
            playerState: playerState,
          )
        ],
      ),
    );
  }
}
