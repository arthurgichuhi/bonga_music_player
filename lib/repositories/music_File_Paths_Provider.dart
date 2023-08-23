// ignore: file_names
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';

//Currrent Playing Music File Path Provider
final currentTrackProvider = StateProvider<String>((ref) => '');
//All Music File Paths
final allMusicTrackProvider = StateProvider<List<String>>((ref) => []);
//Current Music File Paths Provider
final currentMusicFilePathsProvider = StateProvider<List<String>>((ref) => []);
//Current Music File Paths Metadata
final currentFilePathsMetadataProvider =
    StateProvider<List<Metadata?>>((ref) => []);
//Music Play State Provider
final playerStateProvider = StateProvider<bool>((ref) => false);
//Current Playlist database ID
final playListIdDb = StateProvider<int?>((ref) => null);
//Looping Status
final loopingStatusProvider = StateProvider<int>((ref) => 0);
