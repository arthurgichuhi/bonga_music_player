import 'package:audioplayers/audioplayers.dart';
import 'package:bonga_music/repositories/music_File_Paths_Provider.dart';
import 'package:bonga_music/theme.dart';
import 'package:bonga_music/widgets/glowing_action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({
    super.key,
    required this.position,
    required this.duration,
  });
  final Duration position;
  final Duration duration;

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String currentPosition = '0.0';

  ValueNotifier<int> track = ValueNotifier(0);
  ValueNotifier<String> currentTrack = ValueNotifier('');
  List<Metadata?> songData = [];
  List<String> sortedFilePaths = [];
  bool shuffle = false;
  bool loop = false;
  @override
  void initState() {
    super.initState();
    position = widget.position;
    duration = widget.duration;
  }

  Future initializeAudio() async {
    ref.watch(audioPlayerProvider).setReleaseMode(
        ref.watch(loopingStatusProvider) == 1
            ? ReleaseMode.loop
            : ReleaseMode.stop);
    // widget.audioPlayer.setSourceDeviceFile(currentTrack.value);
  }

  //initialize listenser
  void audioPlayerListeners() {
    //
    ref.read(audioPlayerProvider).onPlayerStateChanged.listen((playerState) {
      if (mounted) {
        ref
            .read(playerStateProvider.notifier)
            .update((state) => playerState == PlayerState.playing);
      }
    });
    //
    ref.read(audioPlayerProvider).onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });
//
    ref.read(audioPlayerProvider).onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
          currentPosition = '${position.inMinutes}:${position.inSeconds % 60}';
        });
      }
    });
    //
    ref.read(audioPlayerProvider).onPlayerComplete.listen((event) async {
      ref.read(loopingStatusProvider) == 0
          ? await ref.read(audioPlayerProvider).stop()
          : ref.watch(loopingStatusProvider) == 2
              ? () => nextTrack()
              : await ref
                  .read(audioPlayerProvider)
                  .setReleaseMode(ReleaseMode.loop);
    });
  }

//update song data
  void updateSongData() async {
    ref.read(currentTrackProvider.notifier).update(
        (state) => ref.watch(currentMusicFilePathsProvider)[track.value]);

    await ref
        .read(audioPlayerProvider)
        .setSource(UrlSource(ref.watch(currentTrackProvider)));

    // .play(UrlSource(ref.read(currentTrackProvider)));
    position = const Duration(seconds: 0);
    ref.read(audioPlayerProvider).onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    ref.read(audioPlayerProvider).onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
        currentPosition =
            '${position.inMinutes}:${position.inSeconds % 60 < 10 ? '0${position.inSeconds % 60}' : '${position.inSeconds}'}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeAudio();
    audioPlayerListeners();
    // if (mounted) {
    //   ref.listen(currentTrackProvider, (previous, next) {
    //     ref
    //         .read(audioPlayerProvider)
    //         .play(UrlSource(ref.watch(currentTrackProvider)));
    //   });
    // }
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
                    child: ref
                                .watch(musicFilePathMetadataProvider)
                                .where((element) =>
                                    element.keys.first ==
                                    ref.read(currentTrackProvider))
                                .first
                                .values
                                .first
                                ?.picture
                                ?.data !=
                            null
                        ? Image.memory(
                            ref
                                .watch(musicFilePathMetadataProvider)
                                .where((element) =>
                                    element.keys.first ==
                                    ref.read(currentTrackProvider))
                                .first
                                .values
                                .first!
                                .picture!
                                .data,
                            height: MediaQuery.of(context).size.height * .65,
                          )
                        : Icon(
                            CupertinoIcons.music_note,
                            color: AppColors.accent,
                            size: MediaQuery.of(context).size.height * .65,
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
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // IconButton(
                              //     onPressed: () {},
                              //     icon: const Icon(
                              //       Icons.favorite,
                              //       color: AppColors.cardLight,
                              //     )),
                              // IconButton(
                              //     onPressed: () {},
                              //     icon: const Icon(
                              //       Icons.search,
                              //       color: AppColors.cardLight,
                              //     )),
                              // PopupMenuButton(
                              //   color: AppColors.cardLight,
                              //   itemBuilder: (context) {
                              //     List<Text> labels = [
                              //       const Text('Edit Tags'),
                              //       const Text('Delete All')
                              //     ];
                              //     List<VoidCallback> callBacks = [() {}, () {}];
                              //     return List.generate(
                              //         3,
                              //         (index) => PopupMenuItem(
                              //               onTap: callBacks[index],
                              //               child: labels[index],
                              //             ));
                              //   },
                              // )
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
                          ref
                                  .watch(musicFilePathMetadataProvider)
                                  .where((element) =>
                                      element.keys.first ==
                                      ref.read(currentTrackProvider))
                                  .first
                                  .values
                                  .first
                                  ?.title ??
                              "Unknown",
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
                                Text(
                                    ref
                                            .watch(
                                                musicFilePathMetadataProvider)
                                            .where((element) =>
                                                element.keys.first ==
                                                ref.read(currentTrackProvider))
                                            .first
                                            .values
                                            .first
                                            ?.artist ??
                                        "Unknown",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.7)),
                                const Divider(
                                  height: 5,
                                ),
                                Text(
                                    ref
                                            .watch(
                                                musicFilePathMetadataProvider)
                                            .where((element) =>
                                                element.keys.first ==
                                                ref.read(currentTrackProvider))
                                            .first
                                            .values
                                            .first
                                            ?.album ??
                                        "Unknown",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.7))
                              ],
                            ),
                            Text(
                                '${ref.watch(currentMusicFilePathsProvider).indexWhere((element) => element == ref.read(currentTrackProvider)) + 1} / ${ref.read(currentMusicFilePathsProvider).length}',
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
                        await ref.read(audioPlayerProvider).seek(position);
                      }),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(currentPosition.length < 2
                            ? "0$currentPosition"
                            : currentPosition),
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
                            color: ref.watch(shuffleProvider)
                                ? AppColors.accent
                                : AppColors.cardDark,
                            icon: Icons.shuffle,
                            onPressed: shuffleFilePaths),
                        GlowingActionButton.small(
                            color: AppColors.accent,
                            icon: Icons.arrow_back_ios_new,
                            onPressed: previousTrack),
                        GlowingActionButton(
                            color: AppColors.accent,
                            icon: !ref.watch(playerStateProvider)
                                ? Icons.play_arrow
                                : Icons.pause,
                            onPressed: playOrPause),
                        GlowingActionButton.small(
                            color: AppColors.accent,
                            icon: Icons.arrow_forward_ios_rounded,
                            onPressed: nextTrack),
                        GlowingActionButton.small(
                            color: ref.read(loopingStatusProvider) > 0
                                ? AppColors.accent
                                : AppColors.cardDark,
                            icon: Icons.repeat,
                            onPressed: setLooping)
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

  //shuffle file paths
  void shuffleFilePaths() {
    bool shuffle = ref.read(shuffleProvider);
    ref.read(shuffleProvider.notifier).update((state) => !shuffle);
    if (shuffle) {
      List<String> musicFiles = ref.read(currentMusicFilePathsProvider);
      musicFiles.shuffle();
      ref
          .read(currentMusicFilePathsProvider.notifier)
          .update((state) => musicFiles);
    }
  }

  //navigate to previous track
  void previousTrack() {
    track.value == 0
        ? track.value = 0
        // track.value = ref.read(currentMusicFilePathsProvider).length - 1
        : track.value--;
    updateSongData();
  }

  //play and pause controll
  void playOrPause() async {
    if (ref.read(playerStateProvider)) {
      await ref.read(audioPlayerProvider).pause();
      ref.read(playerStateProvider.notifier).update((state) => false);
      // widget.playerState.value = widget.isPlaying.value;
    } else {
      // await audioPlayer.resume();
      await ref
          .read(audioPlayerProvider)
          .play(UrlSource(ref.read(currentTrackProvider)));

      ref.read(playerStateProvider.notifier).update((state) => true);
      // widget.playerState.value = widget.isPlaying.value;
    }
  }

  //navigate to next track
  void nextTrack() {
    track.value == ref.read(currentMusicFilePathsProvider).length - 1
        ? track.value = 0
        : track.value += 1;
    // ref.watch(loopingStatusProvider) == 1
    //     ? ref.watch(audioPlayerProvider).setReleaseMode(ReleaseMode.loop)
    //     : ref.watch(loopingStatusProvider) == 2
    //         ? ref.watch(audioPlayerProvider).setReleaseMode(ReleaseMode.release)
    //         : ref.watch(audioPlayerProvider).setReleaseMode(ReleaseMode.stop);
    updateSongData();
  }

  //set looping
  void setLooping() {
    int loop = ref.read(loopingStatusProvider);
    loop == 2 ? loop = 0 : loop++;
    ref.read(loopingStatusProvider.notifier).update((state) => loop);
    loop == 1
        ? ref.read(audioPlayerProvider).setReleaseMode(ReleaseMode.loop)
        : loop == 0
            ? ref.read(audioPlayerProvider).setReleaseMode(ReleaseMode.stop)
            : null;
  }
}
