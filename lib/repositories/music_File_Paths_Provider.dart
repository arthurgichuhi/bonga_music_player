// ignore: file_names
import 'package:bonga_music/database/playlists/playlist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';

//Currrent Playing Music File Path Provider
final currentTrackProvider = StateProvider<String>((ref) => '');
//Current Track Metadata
final currentTrackMetadataProvider = StateProvider<Metadata?>((ref) => null);
//All Music File Paths
final allMusicTrackProvider = StateProvider<List<String>>((ref) => []);
//Music file paths and metadata List<String,Metadata where String is the
//file path of music file
final musicFilePathMetadataProvider =
    StateProvider<List<Map<String, Metadata?>>>((ref) => []);
//Current Music File Paths Provider
final currentMusicFilePathsProvider = StateProvider<List<String>>((ref) => []);
//Music Play State Provider
final playerStateProvider = StateProvider<bool>((ref) => false);
//Current Playlist database ID
final playListIdDb = StateProvider<int?>((ref) => null);
//Looping Status
final loopingStatusProvider = StateProvider<int>((ref) => 0);
//PlayLists State Provider
final playListsProvider = StateProvider<List<PlayLists>>((ref) => []);
