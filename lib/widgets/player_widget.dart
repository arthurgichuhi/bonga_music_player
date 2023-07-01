import 'package:audioplayers/audioplayers.dart';
import 'package:bonga_music/api/songs.dart';
import 'package:bonga_music/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';

class Player extends StatefulWidget {
  const Player({super.key, required this.musicFiles});
  final List<String> musicFiles;
  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String currentPosition = '';
  bool isPlaying = false;
  ValueNotifier<int> track = ValueNotifier(0);
  ValueNotifier<Metadata> metaData = ValueNotifier(const Metadata());
  @override
  void initState() {
    initializeAudio();
    MusicAPI()
        .getMusicMetaData(widget.musicFiles[track.value])
        .then((value) => metaData.value = value!);
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

//this function updates track data when user changes track
  updateTrackData() {
    audioPlayer.setSourceDeviceFile(widget.musicFiles[track.value]);
    MusicAPI()
        .getMusicMetaData(widget.musicFiles[track.value])
        .then((value) => metaData.value = value!);

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
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 172,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(metaData.value.title != null
                          ? metaData.value.title!
                          : ''),
                      const Divider(
                        height: 1,
                      ),
                      Text(metaData.value.artist != null
                          ? metaData.value.artist!
                          : ''),
                    ],
                  ),
                  metaData.value.picture != null
                      ? Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Image.memory(
                            metaData.value.picture!.data,
                            height: 50,
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(
                            CupertinoIcons.music_note,
                            size: 50,
                          ),
                        )
                ]),
          ),
          const Divider(
            height: 0.2,
          ),
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
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currentPosition),
                Text('${duration.inMinutes}:${duration.inSeconds % 60}')
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //this button triggers the player to move to the previous music file in the list
                IconButton(
                    onPressed: () {
                      if (track.value == 0) {
                        track.value = 0;
                      } else {
                        track.value -= 1;
                        updateTrackData();
                      }
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                //this button triggers play and pause of playing music audio file
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
                //this button is to play the next track on the list
                IconButton(
                    onPressed: () {
                      track.value += 1;
                      updateTrackData();
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
