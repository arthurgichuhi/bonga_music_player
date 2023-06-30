import 'package:audioplayers/audioplayers.dart';
import 'package:bonga_music/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';

class Player extends StatefulWidget {
  const Player(
      {super.key, required this.musicFiles, required this.musicDetails});
  final List<String> musicFiles;
  final List<Metadata> musicDetails;
  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String currentPosition = '';
  Metadata? musicDetails;
  bool isPlaying = false;
  ValueNotifier<int> track = ValueNotifier(0);
  @override
  void initState() {
    initializeAudio();
    // MusicAPI()
    //     .getMusicMetaData(widget.musicFiles[track.value])
    //     .then((value) => musicDetails);
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
        currentPosition = '${position.inMinutes}:${position.inSeconds % 60}';
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future initializeAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    audioPlayer.setSourceDeviceFile(widget.musicFiles[track.value]);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Column(
        children: [
          Text(audioPlayer.playerId),
          Divider(),
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
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(currentPosition),
                  Text('${duration.inMinutes}:${duration.inSeconds % 60}')
                ],
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      track.value -= 1;
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                IconButton(
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      } else {
                        await audioPlayer
                            .play(UrlSource(widget.musicFiles[track.value]));
                        setState(() {
                          isPlaying = true;
                        });
                      }
                    },
                    icon: Icon(isPlaying
                        ? CupertinoIcons.pause_fill
                        : CupertinoIcons.play_fill)),
                IconButton(
                    onPressed: () {
                      track.value += 1;
                    },
                    icon: const Icon(Icons.arrow_forward_ios_rounded))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
