import 'package:bonga_music/repositories/music_File_Paths_Provider.dart';
import 'package:bonga_music/screen/music_resources.dart';
import 'package:bonga_music/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:permission_handler/permission_handler.dart';

import 'api/music_player_logic_operations.dart';
import 'database/db_api/db_operations_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MetadataGod.initialize();
  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }
  runApp(ProviderScope(
      child: MaterialApp(
    theme: AppTheme.dark(),
    home: const MyApp(),
    debugShowCheckedModeBanner: false,
  )));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    initializeStates();
    super.initState();
  }

  void initializeStates() async {
    await IsarDBServices().getSavedMusicFiles().then((value) {
      if (value.isEmpty) {
        MusicAPI().getLocalMusicFiles().then((value) async {
          await IsarDBServices().getSavedMusicFiles().then((value) {
            ref
                .read(allMusicTrackProvider.notifier)
                .update((state) => value[0].musicFilePaths!);
          });
        });
      }
      debugPrint("Main page provider ${value[0].musicFilePaths!.length}");
      ref
          .read(allMusicTrackProvider.notifier)
          .update((state) => value[0].musicFilePaths!);
      debugPrint(
          "Provider state ${ref.read(allMusicTrackProvider.notifier).update((state) => value[0].musicFilePaths!).length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MusicResources();
  }
}
