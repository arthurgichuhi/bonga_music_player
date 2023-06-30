import 'package:isar/isar.dart';
part 'playlist.g.dart';

@Collection(accessor: 'playlists')
class PlayLists {
  Id id = Isar.autoIncrement;
  List<String>? play_list_songs;
}
