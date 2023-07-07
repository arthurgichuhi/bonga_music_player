import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:bonga_music/theme.dart';
import 'package:bonga_music/widgets/glowing_action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen(
      {super.key,
      required this.song,
      required this.songs,
      required this.albumArt});
  final ValueNotifier<String> song;
  final Uint8List? albumArt;
  final List<String> songs;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String currentPosition = '';
  bool isPlaying = false;
  ValueNotifier<int> track = ValueNotifier(0);
  ValueNotifier<Metadata> metaData = ValueNotifier(const Metadata());
  ValueNotifier<String> currentTrack = ValueNotifier('');
  @override
  void initState() {
    super.initState();
    // getMusicMetaData();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future initializeAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.release);
    currentTrack.value = widget.song.value;
    audioPlayer.setSourceDeviceFile(currentTrack.value);
  }

  void getMusicMetaData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                child: Stack(
              children: [
                Hero(
                  tag: 'hero-album-art',
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: widget.albumArt != null
                        ? Image.memory(widget.albumArt!)
                        : const Icon(CupertinoIcons.music_note),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 32.5),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 25,
                              )),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.46,
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: AppColors.cardLight,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.search,
                                    color: AppColors.cardLight,
                                  )),
                              PopupMenuButton(
                                color: AppColors.cardLight,
                                itemBuilder: (context) {
                                  List<Text> labels = [
                                    const Text('Edit Tags'),
                                    const Text('Delete All')
                                  ];
                                  List<VoidCallback> callBacks = [() {}, () {}];
                                  return List.generate(
                                      3,
                                      (index) => PopupMenuItem(
                                            onTap: callBacks[index],
                                            child: labels[index],
                                          ));
                                },
                              )
                            ],
                          )
                        ],
                      )),
                )
              ],
            )),
            SizedBox(
              child: Column(
                children: [
                  Text(
                    '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [],
                      ),
                      Text('${widget.songs.indexOf(currentTrack.value)}'),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              child: Column(
                children: [
                  Slider(
                      activeColor: AppColors.accent,
                      inactiveColor: Colors.white,
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble(),
                      onChanged: (value) async {
                        final position = Duration(seconds: value.toInt());
                        await audioPlayer.seek(position);
                      }),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(currentPosition),
                        Text('${duration.inMinutes}:${duration.inSeconds % 60}')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6, right: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GlowingActionButton.small(
                            color: AppColors.accent,
                            icon: Icons.shuffle,
                            onPressed: () {}),
                        GlowingActionButton.small(
                            color: AppColors.accent,
                            icon: Icons.arrow_back_ios_new,
                            onPressed: () {}),
                        GlowingActionButton(
                            color: AppColors.accent,
                            icon: Icons.play_arrow,
                            onPressed: () {}),
                        GlowingActionButton.small(
                            color: AppColors.accent,
                            icon: Icons.arrow_forward_ios_rounded,
                            onPressed: () {}),
                        GlowingActionButton.small(
                            color: AppColors.accent,
                            icon: CupertinoIcons.loop,
                            onPressed: () {})
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
