import 'package:bonga_music/database/playlists/playlist.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDBServices {
  late Future<Isar> db;
  IsarDBServices() {
    db = openDB();
  }
  //this function saves playlist data when
  //new playlist is created
  Future<void> savePlayListData({required PlayLists playLists}) async {
    final isar = await db;
    isar.writeTxn(() => isar.playlists.put(playLists));
  }

  //this functions returns a list of all created playlists
  //data from the database
  Future<List<PlayLists>> getListOfPlaylists() async {
    final isar = await db;
    return isar.playlists.where().findAll();
  }

//this function initializes and returns the Isar database object
  Future<Isar> openDB() async {
    var dbPath = (await getApplicationDocumentsDirectory()).path;
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([PlayListsSchema],
          directory: dbPath, inspector: true);
    }
    return Future.value(Isar.getInstance());
  }
}
