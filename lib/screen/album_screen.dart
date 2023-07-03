import 'dart:typed_data';

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
  final List<String?> musicTitle;
  final List<String?> trackArtists;

  @override
  State<AlbumViewScreen> createState() => _AlbumViewScreenState();
}

class _AlbumViewScreenState extends State<AlbumViewScreen> {
  double? totalDuration;

  @override
  void initState() {
    super.initState();
    for (var time in widget.duration) {
      debugPrint('Duration.........${widget.duration.length}');
      // setState(() {
      //   totalDuration = totalDuration! + time!;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Card(
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.30,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.height * 0.30,
                          child: Image.memory(
                            widget.albumArt,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 160, child: Text(widget.albumName)),
                              const Divider(
                                height: 1,
                              ),
                              Text(widget.albumArtist),
                              Text('$totalDuration')
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: widget.songs.length,
            itemBuilder: (context, index) {
              return Card(
                child: Column(
                  children: [Text(widget.musicTitle[index]!)],
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
