import 'package:bonga_music/screen/music_resources.dart';
import 'package:bonga_music/theme.dart';
import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MetadataGod.initialize();
  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }
  runApp(MaterialApp(
    theme: AppTheme.dark(),
    home: const MusicResources(),
    debugShowCheckedModeBanner: false,
  ));
}
