import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:metadata_god/metadata_god.dart';
// import 'package:metadata_god/metadata_god.dart';

class MusicFileInfo {
  List<String> musicFiles;
  List<Metadata> musicDetails;

  MusicFileInfo({required this.musicFiles, required this.musicDetails});
}

final class MusicAPI {
  // ignore: non_constant_identifier_names
  Future<List<String>> getLocalMusicFiles() async {
    // Get the directory of the device's internal storage.
    Directory internalStorageDirectory = Directory('/storage/emulated/0/Music');

    // Get a list of all the files in the directory.
    List<FileSystemEntity> files =
        internalStorageDirectory.listSync(recursive: true);

    // Create a list to store the music files.
    List<String> musicFiles = [];

    // Iterate through the files and add any files that are .mp3 files to the music files list.
    for (FileSystemEntity file in files) {
      if (file.path.endsWith('.mp3') ||
          file.path.endsWith('.m4a') ||
          file.path.endsWith('aac')) {
        musicFiles.add(file.path);
      }
    }
    debugPrint('Music Files........................${musicFiles.length}');
    // for (var music in musicFiles) {
    //   var detail = await MetadataGod.readMetadata(file: music);
    //   musicDetails.add(detail);
    // }

    return musicFiles;
    // Iterate through the music files and print the metadata for each file.
    // for (FileSystemEntity file in musicFiles) {
    //   debugPrint('Music................files...........${file.path}.........');
    //   Metadata metadata = await MetadataGod.readMetadata(file: file.path);
    // }
  }

  Future<Metadata> getMusicMetaData(String file) async {
    var metaData = await MetadataGod.readMetadata(file: file);
    debugPrint(metaData.title);
    return metaData;
  }
}
