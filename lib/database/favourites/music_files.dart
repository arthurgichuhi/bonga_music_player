import 'package:isar/isar.dart';
part 'music_files.g.dart';

@Collection(accessor: 'favourites')
class MusicFavourites {
  Id id = Isar.autoIncrement;
  String? path;
}
