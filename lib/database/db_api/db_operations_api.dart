import 'package:bonga_music/database/music_files_database/all_music_file_paths.dart';
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
    isar.writeTxnSync(() => isar.playlists.putSync(playLists));
  }

  //this function saves all retrieved music file paths
  Future<void> saveReadMusicFiles(
      {required AllMusicFiles allMusicFiles}) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.allMusicFiles.putSync(allMusicFiles));
  }

  //this function returns a list of all saved music files
  Future<List<AllMusicFiles>> getSavedMusicFiles() async {
    final isar = await db;
    return await isar.allMusicFiles.where().findAll();
  }

  //this function retrieves playlist data objecc
  Future<PlayLists?> getPlayListData(int id) async {
    final isar = await db;
    return await isar.playlists.get(id);
  }

  Stream<PlayLists?> streamPlaylistData(int id) async* {
    final isar = await db;
    yield* isar.playlists.watchObject(id);
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
      return await Isar.open([PlayListsSchema, AllMusicFilesSchema],
          directory: dbPath, inspector: true);
    }
    return Future.value(Isar.getInstance());
  }
}
