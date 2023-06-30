import 'package:bonga_music/screen/music_resources.dart';
import 'package:bonga_music/theme.dart';
import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MetadataGod.initialize();
  runApp(MaterialApp(
    theme: AppTheme.dark(),
    home: const MusicResources(),
  ));
}
