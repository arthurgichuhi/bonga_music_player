import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:bonga_music/api/music_player_logic_operations.dart';
import 'package:bonga_music/theme.dart';
import 'package:bonga_music/widgets/glowing_action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';

import 'music_resources.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen(
      {super.key,
      required this.song,
      required this.songs,
      required this.albumArt,
      required this.audioPlayer,
      required this.position,
      required this.duration,
      required this.songMetaData,
      required this.isPlaying});
  final ValueNotifier<String> song;
  final Uint8List? albumArt;
  final List<String> songs;
  final AudioPlayer audioPlayer;
  final Duration position;
  final Duration duration;
  final ValueNotifier<Metadata?> songMetaData;
  final ValueNotifier<bool> isPlaying;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String currentPosition = '0.0';

  ValueNotifier<int> track = ValueNotifier(0);
  // ValueNotifier<Metadata> metaData = ValueNotifier(const Metadata());
  ValueNotifier<String> currentTrack = ValueNotifier('');
  List<Metadata?> songData = [];
  List<String> sortedFilePaths = [];
  bool shuffle = false;
  bool loop = false;
  @override
  void initState() {
    super.initState();
    // getMusicMetaData();
    initializeAudio();
    // track.value =
    //     widget.songs.indexWhere((element) => element == widget.song.value);
    position = widget.position;
    duration = widget.duration;
    widget.audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          widget.isPlaying.value = state == PlayerState.playing;
        });
      }
    });

    widget.audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    widget.audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
          currentPosition = '${position.inMinutes}:${position.inSeconds % 60}';
        });
      }
    });
    getSongsMetadata();
  }

  Future<void> getSongsMetadata() async {
    for (var file in widget.songs) {
      await MusicAPI()
          .getMusicMetaData(file)
          .then((value) => setState(() => songData.add(value)));
    }
    debugPrint('Metadta...................${songData.length}');
  }

  listenForTrackChanges() {
    widget.song.addListener(() async {
      // debugPrint(
      //     '*******....................${widget.currentTrack.value}..................*******');
      updateSongData(track.value);
      if (widget.isPlaying.value) {
        await widget.audioPlayer.pause();
        setState(() {
          widget.isPlaying.value = false;
        });
        // widget.playerState.value = widget.isPlaying.value;
      } else {
        // await audioPlayer.resume();
        await widget.audioPlayer.play(UrlSource(widget.songs[track.value]));

        setState(() {
          widget.isPlaying.value = true;
        });
        // widget.playerState.value = widget.isPlaying.value;
      }
    });
  }

  Future initializeAudio() async {
    widget.audioPlayer.setReleaseMode(
        loopStatus.value == 1 ? ReleaseMode.loop : ReleaseMode.release);
    currentTrack.value = widget.song.value;
    // widget.audioPlayer.setSourceDeviceFile(currentTrack.value);
  }

  void updateSongData(int currentTrack) async {
    // setState(() {
    widget.song.value = widget.songs[track.value];
    widget.songMetaData.value = songData[track.value]!;
    // });
    // widget.audioPlayer.setSourceDeviceFile(widget.song.value);
    widget.audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    widget.audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
        currentPosition =
            '${position.inMinutes}:${position.inSeconds % 60 < 10 ? '0${position.inSeconds % 60}' : '${position.inSeconds}'}';
      });
    });
  }

  @override
  void dispose() {
    // widget.audioPlayer.dispose();
    super.dispose();
  }

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
                        : const Icon(
                            CupertinoIcons.music_note,
                            size: 70,
                          ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 17.5),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 14, top: 10, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.songMetaData.value!.title!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.7),
                        ),
                        const Divider(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.songMetaData.value!.artist!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.7)),
                                const Divider(
                                  height: 5,
                                ),
                                Text(widget.songMetaData.value!.album!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.7))
                              ],
                            ),
                            Text(
                                '${trackFilePaths.value.indexWhere((element) => element == currentTrackPath.value) + 1} / ${trackFilePaths.value.length}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.7))
                          ],
                        )
                      ],
                    ),
                  ),
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
                        await widget.audioPlayer.seek(position);
                      }),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(currentPosition),
                        Text(
                            '${duration.inMinutes}:${duration.inSeconds % 60 < 10 ? '0${duration.inSeconds % 60}' : '${duration.inSeconds % 60}'}')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6, right: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GlowingActionButton.small(
                            color:
                                shuffle ? AppColors.accent : AppColors.cardDark,
                            icon: Icons.shuffle,
                            onPressed: () {
                              setState(() => shuffle = !shuffle);
                            }),
                        GlowingActionButton.small(
                            color: AppColors.accent,
                            icon: Icons.arrow_back_ios_new,
                            onPressed: () {
                              debugPrint('${track.value}');
                              track.value == 0
                                  ? track.value = widget.songs.length - 1
                                  : track.value -= 1;
                              updateSongData(track.value);
                            }),
                        GlowingActionButton(
                            color: AppColors.accent,
                            icon: !widget.isPlaying.value
                                ? Icons.play_arrow
                                : Icons.pause,
                            onPressed: () async {
                              if (widget.isPlaying.value) {
                                await widget.audioPlayer.pause();
                                setState(() {
                                  widget.isPlaying.value = false;
                                });
                                // widget.playerState.value = widget.isPlaying.value;
                              } else {
                                // await audioPlayer.resume();
                                await widget.audioPlayer
                                    .play(UrlSource(currentTrack.value));

                                setState(() {
                                  widget.isPlaying.value = true;
                                });
                                // widget.playerState.value = widget.isPlaying.value;
                              }
                            }),
                        GlowingActionButton.small(
                            color: AppColors.accent,
                            icon: Icons.arrow_forward_ios_rounded,
                            onPressed: () {
                              track.value == widget.songs.length - 1
                                  ? track.value = 0
                                  : track.value += 1;
                              updateSongData(track.value);
                            }),
                        GlowingActionButton.small(
                            color: loop ? AppColors.accent : AppColors.cardDark,
                            icon: CupertinoIcons.loop,
                            onPressed: () {
                              setState(() => loop = !loop);
                            })
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
