import 'package:isar/isar.dart';
part 'all_music_file_paths.g.dart';

@Collection(accessor: 'allMusicFiles')
class AllMusicFiles {
  Id? id;
  List<String>? musicFilePaths;
}
