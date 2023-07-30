import 'package:audioplayers/audioplayers.dart';
import 'package:bonga_music/api/songs.dart';
import 'package:bonga_music/screen/player_screen.dart';
import 'package:bonga_music/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';

import '../screen/music_resources.dart';

class Player extends StatefulWidget {
  const Player({
    super.key,
    required this.musicFiles,
    required this.screen,
    required this.currentTrack,
    required this.playerState,
  });
  final List<String> musicFiles;
  final String? screen;
  final ValueNotifier<String> currentTrack;
  final ValueNotifier<bool> playerState;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
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
        .getMusicMetaData(widget.currentTrack.value)
        .then((value) => metaData.value = value!);
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
          currentPosition = '${position.inMinutes}:${position.inSeconds % 60}';
        });
      }
    });
    audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        track.value += 1;
        if (track.value == widget.musicFiles.length - 1 &&
            loopStatus.value == 2) {
          track.value = 0;
        }
        widget.currentTrack.value = widget.musicFiles[track.value];
        updateTrackData(widget.currentTrack.value);
        audioPlayer.play(UrlSource(currentTrackPath.value));
      }
    });
    listenForTrackChanges();

    super.initState();
  }

  Future initializeAudio() async {
    audioPlayer.setReleaseMode(
        loopStatus.value == 1 ? ReleaseMode.loop : ReleaseMode.release);
    // widget.currentTrack.value = widget.musicFiles[track.value];
    // audioPlayer.setSourceDeviceFile(widget.currentTrack.value);
    MusicAPI()
        .getMusicMetaData(currentTrackPath.value)
        .then((value) => setState(() => metaData.value = value!));
  }

  //this function listens for track changes
  listenForTrackChanges() {
    widget.currentTrack.addListener(() async {
      debugPrint(
          '*******....................${widget.currentTrack.value}..................*******');
      updateTrackData(widget.currentTrack.value);
      if (isPlaying) {
        await audioPlayer.pause();
        setState(() {
          isPlaying = false;
        });
        widget.playerState.value = isPlaying;
      } else {
        // await audioPlayer.resume();
        await audioPlayer.play(UrlSource(widget.currentTrack.value));

        if (mounted) {
          setState(() {
            isPlaying = true;
          });
        }
        widget.playerState.value = isPlaying;
      }
    });
  }

//this function updates track data when user changes track
  updateTrackData(String musicTrack) async {
    // await audioPlayer.setSourceDeviceFile(musicTrack);
    setState(() => widget.currentTrack.value = musicTrack);
    MusicAPI()
        .getMusicMetaData(musicTrack)
        .then((value) => metaData.value = value!);

    audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
          currentPosition = '${position.inMinutes}:${position.inSeconds % 60}';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * .37,
          minHeight: MediaQuery.of(context).size.height * .15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Slider(
                    activeColor: AppColors.accent,
                    inactiveColor: Colors.white,
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);
                    }),
              )
            ],
          ),
          widget.screen == null
              ? Padding(
                  padding: const EdgeInsets.only(left: 8, top: 1, bottom: 1),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.sizeOf(context).width * 0.386111,
                              minWidth:
                                  MediaQuery.sizeOf(context).width * 0.380),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlayerScreen(
                                      song: widget.currentTrack,
                                      albumArt: metaData.value.picture!.data,
                                      audioPlayer: audioPlayer,
                                      position: position,
                                      duration: duration,
                                      songMetaData: metaData,
                                      isPlaying: widget.playerState,
                                      songs: trackFilePaths.value,
                                    ),
                                  ));
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(metaData.value.title != null
                                    ? metaData.value.title!
                                    : 'Unknown'),
                                Text(metaData.value.artist != null
                                    ? metaData.value.artist!
                                    : 'Unknown'),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //this button triggers the player to move to the previous music file in the list
                            IconButton(
                                onPressed: () {
                                  if (track.value == 0) {
                                    track.value = widget.musicFiles.length - 1;
                                    widget.currentTrack.value =
                                        widget.musicFiles[track.value];
                                    updateTrackData(widget.currentTrack.value);
                                  } else {
                                    track.value -= 1;
                                    widget.currentTrack.value =
                                        widget.musicFiles[track.value];
                                    updateTrackData(widget.currentTrack.value);
                                  }
                                },
                                icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded)),
                            //this button triggers play and pause of playing music audio file
                            IconButton(
                                onPressed: () async {
                                  if (isPlaying) {
                                    await audioPlayer.pause();
                                    setState(() {
                                      isPlaying = false;
                                    });
                                    widget.playerState.value = isPlaying;
                                  } else {
                                    // await audioPlayer.resume();
                                    await audioPlayer.play(
                                        UrlSource(widget.currentTrack.value));

                                    setState(() {
                                      isPlaying = true;
                                    });
                                    widget.playerState.value = isPlaying;
                                  }
                                },
                                icon: Icon(isPlaying
                                    ? CupertinoIcons.pause_fill
                                    : CupertinoIcons.play_fill)),
                            //this button is to play the next track on the list
                            IconButton(
                                onPressed: () {
                                  if (track.value ==
                                      widget.musicFiles.length - 1) {
                                    track.value = 0;
                                  }
                                  track.value += 1;
                                  widget.currentTrack.value =
                                      widget.musicFiles[track.value];
                                  updateTrackData(widget.currentTrack.value);
                                },
                                icon:
                                    const Icon(Icons.arrow_forward_ios_rounded))
                          ],
                        ),
                        Hero(
                            tag: 'hero-album-art',
                            child: metaData.value.picture != null
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 3),
                                    child: Image.memory(
                                      metaData.value.picture!.data,
                                      height: 59,
                                    ),
                                  )
                                : const Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: Icon(
                                      CupertinoIcons.music_note,
                                      size: 50,
                                    ),
                                  ))
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
