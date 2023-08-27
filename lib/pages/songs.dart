import 'package:bonga_music/repositories/music_File_Paths_Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongsPage extends ConsumerStatefulWidget {
  const SongsPage({super.key});

  @override
  ConsumerState<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends ConsumerState<SongsPage> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(allMusicTrackProvider).isNotEmpty
        ? ListView.builder(
            itemCount: ref.watch(allMusicTrackProvider).length,
            itemBuilder: (context, index) => ListTile(
              leading: Column(
                children: [
                  Text(ref
                          .watch(musicFilePathMetadataProvider)
                          .where((element) =>
                              element.keys.first ==
                              ref.watch(currentTrackProvider))
                          .first
                          .values
                          .first
                          ?.title ??
                      "Unknown"),
                  Text(ref
                          .watch(musicFilePathMetadataProvider)
                          .where((element) =>
                              element.keys.first ==
                              ref.watch(currentTrackProvider))
                          .first
                          .values
                          .first
                          ?.artist ??
                      "Unknown")
                ],
              ),
            ),
          )
        : const Center(
            child: Text("No Music Files Found"),
          );
  }
}
