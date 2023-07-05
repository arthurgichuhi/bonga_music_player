import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:metadata_god/metadata_god.dart';

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
          file.path.endsWith('mp4') ||
          file.path.endsWith('.flac')) {
        musicFiles.add(file.path);
      }
    }
    return musicFiles;
  }

//this method returns audio file metadata
  Future<Metadata?> getMusicMetaData(String file) async {
    Metadata? metadata;
    try {
      await MetadataGod.readMetadata(file: file)
          .then((value) => metadata = value);
    } catch (e) {
      metadata = null;
    }

    return metadata;
  }

//this function retrieves the title of music
  Future<List<String>> getMusicTitles(List<String> musicFiles) async {
    List<String> musicTitle = [];
    for (var file in musicFiles) {
      await getMusicMetaData(file).then((value) {
        if (value.runtimeType != Null && value!.title.runtimeType != Null) {
          musicTitle.add(value.title!);
        } else {
          musicTitle.add('Unknown');
        }
      });
    }
    return musicTitle;
  }

//this function gets data on the specific album the music file is from
  Future<List<String>> getMusicAlbums(List<String> musicFiles) async {
    List<String> musicAlbums = [];
    for (var music in musicFiles) {
      await getMusicMetaData(music).then((value) {
        if (value.runtimeType != Null && value!.album.runtimeType != Null) {
          musicAlbums.add(value.album!);
        } else {
          musicAlbums.add('Unknown');
        }
      });
    }
    return musicAlbums;
  }

  //this function retrieves album art metadata
  Future<List<Uint8List?>> getAlbumArt(List<String> musicFiles) async {
    List<Uint8List?> albumArts = [];
    for (var music in musicFiles) {
      await getMusicMetaData(music).then((value) {
        if (value.runtimeType != Null && value!.picture.runtimeType != Null) {
          albumArts.add(value.picture!.data);
        } else {
          albumArts.add(null);
        }
      });
    }

    return albumArts;
  }

  //this function retrieves the album Artist Data
  Future<List<String>> getAlbumArtist(List<String> musicFiles) async {
    List<String> albumArtist = [];
    for (var file in musicFiles) {
      await getMusicMetaData(file).then((value) {
        if (value.runtimeType != Null &&
            value!.albumArtist.runtimeType != Null) {
          albumArtist.add(value.albumArtist!);
        } else {
          albumArtist.add('Unkown');
        }
      });
    }
    return albumArtist;
  }

  //this function retrieves individual track artist data
  Future<List<String>> getTrackArtist(List<String> musicFiles) async {
    List<String> trackArtists = [];
    for (var file in musicFiles) {
      await getMusicMetaData(file).then((value) {
        if (value.runtimeType != Null && value?.artist.runtimeType != Null) {
          trackArtists.add(value!.artist!);
        } else {
          trackArtists.add('Unknown');
        }
      });
    }
    return trackArtists;
  }

  //this function retrieves music duration data
  Future<List<double?>> getMusicDuration(List<String> musicFiles) async {
    List<double?> musicDuration = [];
    for (var file in musicFiles) {
      await getMusicMetaData(file).then((value) {
        musicDuration.add(value?.durationMs);
      });
    }
    return musicDuration;
  }
}
