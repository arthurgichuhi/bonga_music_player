import 'package:bonga_music/api/music_player_logic_operations.dart';
import 'package:bonga_music/repositories/musicFilePathsProvider.dart';
import 'package:bonga_music/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';

class SongsPage extends ConsumerStatefulWidget {
  const SongsPage({super.key});

  @override
  ConsumerState<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends ConsumerState<SongsPage> {
  List<String> musicFiles = [];
  @override
  void initState() {
    initializeMusicFiles();
    super.initState();
  }

  //initialize music files
  void initializeMusicFiles() async {
    List<Map<String, Metadata?>> musicFilesMetadata = [];
    await MusicAPI()
        .getLocalMusicFiles()
        .then((value) => setState(() => musicFiles = value));
    for (var music in musicFiles) {
      await MusicAPI()
          .getMusicMetaData(music)
          .then((value) => musicFilesMetadata.add({music: value}));
    }
    if (mounted) {
      ref.read(musicFilePathMetadataProvider).isEmpty
          ? ref
              .read(musicFilePathMetadataProvider.notifier)
              .update((state) => musicFilesMetadata)
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: musicFiles.isNotEmpty
            ? ListView.builder(
                itemCount: musicFiles.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    ref
                        .read(currentTrackProvider.notifier)
                        .update((state) => musicFiles[index]);
                    ref
                        .read(currentMusicFilePathsProvider.notifier)
                        .update((state) => musicFiles);
                  },
                  child: ListTile(
                    leading: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ref
                                  .watch(musicFilePathMetadataProvider)
                                  .where((element) =>
                                      element.keys.first == musicFiles[index])
                                  .first
                                  .values
                                  .first
                                  ?.title ??
                              "Unknown",
                          style: TextStyle(
                              color: ref.watch(currentTrackProvider) ==
                                      musicFiles[index]
                                  ? AppColors.accent
                                  : null),
                        ),
                        Text(
                            ref
                                    .watch(musicFilePathMetadataProvider)
                                    .where((element) =>
                                        element.keys.first == musicFiles[index])
                                    .first
                                    .values
                                    .first
                                    ?.artist ??
                                "Unknown",
                            style: TextStyle(
                                color: ref.watch(currentTrackProvider) ==
                                        musicFiles[index]
                                    ? AppColors.accent
                                    : null))
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: Text("No Music Files Found"),
              ));
  }
}
