import 'package:audioplayers/audioplayers.dart';
import 'package:bonga_music/api/music_player_logic_operations.dart';
import 'package:bonga_music/repositories/music_File_Paths_Provider.dart';
import 'package:bonga_music/screen/player_screen.dart';
import 'package:bonga_music/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';

import '../screen/music_resources.dart';

class Player extends ConsumerStatefulWidget {
  const Player({
    super.key,
    required this.screen,
  });
  final String? screen;
  @override
  ConsumerState<Player> createState() => _PlayerState();
}

class _PlayerState extends ConsumerState<Player> {
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String currentPosition = '';
  bool isPlaying = false;
  ValueNotifier<int> track = ValueNotifier(0);
  ValueNotifier<int> loopStatus = ValueNotifier(0);
  ValueNotifier<Metadata?> metaData = ValueNotifier(const Metadata());
  @override
  void initState() {
    initializeAudio();
    MusicAPI()
        .getMusicMetaData(ref.read(currentTrackProvider))
        .then((value) => metaData.value = value);
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
        if (track.value == ref.read(currentMusicFilePathsProvider).length - 1 &&
            loopStatus.value == 2) {
          track.value = 0;
        }
        ref.watch(currentTrackProvider.notifier).update(
            (state) => ref.read(currentMusicFilePathsProvider)[track.value]);
        updateTrackData(ref.read(currentTrackProvider));
        audioPlayer.play(UrlSource(ref.read(currentTrackProvider)));
      }
    });
    super.initState();
  }

  Future initializeAudio() async {
    audioPlayer.setReleaseMode(
        loopStatus.value == 1 ? ReleaseMode.loop : ReleaseMode.release);
    MusicAPI()
        .getMusicMetaData(ref.read(currentTrackProvider))
        .then((value) => setState(() => metaData.value = value));
  }

//this function updates track data when user changes track
  updateTrackData(String musicTrack) async {
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
                                      albumArt: metaData.value?.picture!.data,
                                      audioPlayer: audioPlayer,
                                      position: position,
                                      duration: duration,
                                      songMetaData: metaData,
                                    ),
                                  ));
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(metaData.value?.title ?? 'Unknown'),
                                Text(metaData.value?.artist ?? 'Unknown'),
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
                                    track.value = ref
                                            .read(currentMusicFilePathsProvider)
                                            .length -
                                        1;
                                    ref
                                        .read(currentTrackProvider.notifier)
                                        .update((state) => ref.read(
                                                currentMusicFilePathsProvider)[
                                            track.value]);
                                    updateTrackData(
                                        ref.read(currentTrackProvider));
                                  } else {
                                    track.value -= 1;
                                    ref
                                        .read(currentTrackProvider.notifier)
                                        .update((state) => ref.read(
                                                currentMusicFilePathsProvider)[
                                            track.value]);

                                    updateTrackData(
                                        ref.read(currentTrackProvider));
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
                                    ref
                                        .read(playerStateProvider.notifier)
                                        .update((state) => isPlaying);
                                  } else {
                                    // await audioPlayer.resume();
                                    await audioPlayer.play(UrlSource(
                                        ref.read(currentTrackProvider)));

                                    setState(() {
                                      isPlaying = true;
                                    });
                                    ref
                                        .read(playerStateProvider.notifier)
                                        .update((state) => isPlaying);
                                  }
                                },
                                icon: Icon(isPlaying
                                    ? CupertinoIcons.pause_fill
                                    : CupertinoIcons.play_fill)),
                            //this button is to play the next track on the list
                            IconButton(
                                onPressed: () {
                                  if (track.value ==
                                      ref
                                              .read(
                                                  currentMusicFilePathsProvider)
                                              .length -
                                          1) {
                                    track.value = 0;
                                  }
                                  track.value += 1;
                                  ref
                                      .read(currentTrackProvider.notifier)
                                      .update((state) => ref.read(
                                              currentMusicFilePathsProvider)[
                                          track.value]);

                                  updateTrackData(
                                      ref.read(currentTrackProvider));
                                },
                                icon:
                                    const Icon(Icons.arrow_forward_ios_rounded))
                          ],
                        ),
                        Hero(
                            tag: 'hero-album-art',
                            child: metaData.value?.picture != null
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 3),
                                    child: Image.memory(
                                      metaData.value!.picture!.data,
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
