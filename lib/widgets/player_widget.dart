import 'package:audioplayers/audioplayers.dart';
import 'package:bonga_music/repositories/music_File_Paths_Provider.dart';
import 'package:bonga_music/screen/player_screen.dart';
import 'package:bonga_music/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: unused_import
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
  ValueNotifier<bool> isPlaying = ValueNotifier(false);
  ValueNotifier<int> track = ValueNotifier(0);
  // ValueNotifier<Metadata?> metaData = ValueNotifier(const Metadata());
  @override
  void initState() {
    initializeAudio();

    super.initState();
  }

//Intitialzie audio player
  Future initializeAudio() async {
    ref.read(audioPlayerProvider).setReleaseMode(
        ref.read(loopingStatusProvider) == 1
            ? ReleaseMode.loop
            : ReleaseMode.release);
  }

  //initialize audio player controller
  void initalizeAudioPlayer() {
    ref.watch(audioPlayerProvider).onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying.value = state == PlayerState.playing;
        });
      }
    });

    ref.watch(audioPlayerProvider).onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    ref.watch(audioPlayerProvider).onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
          currentPosition = '${position.inMinutes}:${position.inSeconds % 60}';
        });
      }
    });
    ref.watch(audioPlayerProvider).onPlayerComplete.listen((event) {
      if (mounted) {
        track.value += 1;
        if (track.value ==
                ref.watch(currentMusicFilePathsProvider).length - 1 &&
            ref.watch(loopingStatusProvider) == 2) {
          track.value = 0;
        }
        ref.watch(currentTrackProvider.notifier).update(
            (state) => ref.watch(currentMusicFilePathsProvider)[track.value]);
        updateTrackData(ref.watch(currentTrackProvider));
        ref
            .watch(audioPlayerProvider)
            .play(UrlSource(ref.watch(currentTrackProvider)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    isPlaying.value = ref.watch(playerStateProvider);
    initalizeAudioPlayer();
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
                      await ref.watch(audioPlayerProvider).seek(position);
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
                                      position: position,
                                      duration: duration,
                                    ),
                                  ));
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //track title
                                Text(ref
                                        .read(musicFilePathMetadataProvider)
                                        .isNotEmpty
                                    ? ref
                                            .watch(
                                                musicFilePathMetadataProvider)
                                            .where((element) =>
                                                element.keys.first ==
                                                ref.watch(currentTrackProvider))
                                            .first
                                            .values
                                            .first
                                            ?.title ??
                                        "Unknown"
                                    : ""),
                                //track Artist(s)
                                Text(ref
                                        .read(musicFilePathMetadataProvider)
                                        .isNotEmpty
                                    ? ref
                                            .watch(
                                                musicFilePathMetadataProvider)
                                            .where((element) =>
                                                element.keys.first ==
                                                ref.watch(currentTrackProvider))
                                            .first
                                            .values
                                            .first
                                            ?.artist ??
                                        "Unknown"
                                    : ""),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //this button triggers the player to move to the previous music file in the list
                            IconButton(
                                onPressed: () => previousTrack(),
                                icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded)),
                            //this button triggers play and pause of playing music audio file
                            IconButton(
                                onPressed: () => playOrPause(),
                                icon: Icon(isPlaying.value
                                    ? CupertinoIcons.pause_fill
                                    : CupertinoIcons.play_fill)),
                            //this button is to play the next track on the list
                            IconButton(
                                onPressed: () => nextTrack(),
                                icon:
                                    const Icon(Icons.arrow_forward_ios_rounded))
                          ],
                        ),
                        Hero(
                            tag: 'hero-album-art',
                            child: ref
                                        .watch(musicFilePathMetadataProvider)
                                        .isNotEmpty &&
                                    ref
                                            .watch(
                                                musicFilePathMetadataProvider)
                                            .where((element) =>
                                                element.keys.first ==
                                                ref.watch(currentTrackProvider))
                                            .first
                                            .values
                                            .first
                                            ?.picture !=
                                        null
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 3),
                                    child: Image.memory(
                                      ref
                                          .watch(musicFilePathMetadataProvider)
                                          .where((element) =>
                                              element.keys.first ==
                                              ref.watch(currentTrackProvider))
                                          .first
                                          .values
                                          .first!
                                          .picture!
                                          .data,
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

//this function updates track data when user changes track
  updateTrackData(String musicTrack) async {
    ref.watch(audioPlayerProvider).onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    ref.watch(audioPlayerProvider).onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
          currentPosition = '${position.inMinutes}:${position.inSeconds % 60}';
        });
      }
    });
  }

//Got to previous Track
  void previousTrack() {
    if (track.value == 0) {
      track.value = ref.watch(currentMusicFilePathsProvider).length - 1;
      ref.watch(currentTrackProvider.notifier).update(
          (state) => ref.watch(currentMusicFilePathsProvider)[track.value]);
      updateTrackData(ref.watch(currentTrackProvider));
    } else {
      track.value -= 1;
      ref.watch(currentTrackProvider.notifier).update(
          (state) => ref.watch(currentMusicFilePathsProvider)[track.value]);

      updateTrackData(ref.watch(currentTrackProvider));
    }
  }

//Play or Pause track
  void playOrPause() async {
    if (isPlaying.value) {
      await ref.watch(audioPlayerProvider).pause();
      setState(() {
        isPlaying.value = false;
      });
      ref.read(playerStateProvider.notifier).update((state) => isPlaying.value);
    } else {
      // await audioPlayer.resume();
      await ref
          .watch(audioPlayerProvider)
          .play(UrlSource(ref.read(currentTrackProvider)));

      setState(() {
        isPlaying.value = true;
      });
      ref.read(playerStateProvider.notifier).update((state) => isPlaying.value);
    }
  }

//Go to next Track
  void nextTrack() {
    if (track.value == ref.watch(currentMusicFilePathsProvider).length - 1) {
      track.value = 0;
    }
    track.value += 1;
    ref.watch(currentTrackProvider.notifier).update(
        (state) => ref.watch(currentMusicFilePathsProvider)[track.value]);

    updateTrackData(ref.watch(currentTrackProvider));
  }
}
