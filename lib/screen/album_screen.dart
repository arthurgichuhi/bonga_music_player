import 'dart:typed_data';
import 'package:bonga_music/models/single_track_enum.dart';
import 'package:bonga_music/screen/music_resources.dart';
import 'package:bonga_music/widgets/player_widget.dart';
import 'package:bonga_music/widgets/track_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlbumViewScreen extends StatefulWidget {
  const AlbumViewScreen(
      {super.key,
      required this.albumArt,
      required this.albumName,
      required this.albumArtist,
      required this.songs,
      required this.duration,
      required this.musicTitle,
      required this.trackArtists});
  final Uint8List? albumArt;
  final String albumName;
  final String albumArtist;
  final List<String> songs;
  final List<double?> duration;
  final List<String> musicTitle;
  final List<String> trackArtists;

  @override
  State<AlbumViewScreen> createState() => _AlbumViewScreenState();
}

class _AlbumViewScreenState extends State<AlbumViewScreen> {
  // ValueNotifier<String> currentTrack = ValueNotifier('');
  ValueNotifier<bool> playerState = ValueNotifier(false);
  // ValueNotifier<bool> doneSorting = ValueNotifier(false);
  // List<Metadata?> songMetatdata = [];
  // List<String> sortedMusicFilePaths = [];
  // List<Metadata?> sortedMetadata = [];
  @override
  void initState() {
    // sortMusicList();
    super.initState();
  }

  // void sortMusicList() async {
  //   var no = 0;
  //   List<Metadata?> temporarySorter = [];
  //   for (var file in widget.songs) {
  //     await MusicAPI()
  //         .getMusicMetaData(file)
  //         .then((value) => setState(() => songMetatdata.add(value)));
  //   }
  //   for (int i = 0; i <= widget.songs.length - 1; i++) {
  //     no = songMetatdata.indexWhere((element) => element?.trackNumber == i + 1);
  //     if (!no.isNegative) {
  //       setState(() {
  //         sortedMusicFilePaths.add(widget.songs[no]);
  //         sortedMetadata.add(songMetatdata[no]);
  //       });
  //     }
  //   }
  //   debugPrint('========+++++$no=======+++++++++++');
  //   if (no.isNegative) {
  //     for (var file in widget.songs) {
  //       await MusicAPI()
  //           .getMusicMetaData(file)
  //           .then((value) => temporarySorter.add(value));
  //     }
  //     temporarySorter.sort((a, b) {
  //       int aTrack = a!.trackNumber!;
  //       int bTrack = b!.trackNumber!;
  //       return aTrack.compareTo(bTrack);
  //     });
  //     for (var data in temporarySorter) {
  //       debugPrint(
  //           '...........................${data!.trackNumber}===================');
  //       setState(() {
  //         sortedMusicFilePaths.add(widget.songs[songMetatdata
  //             .indexWhere((element) => element!.title == data.title)]);
  //         sortedMetadata.add(songMetatdata[songMetatdata
  //             .indexWhere((element) => element!.title == data.title)]);
  //       });
  //     }
  //   }
  //   setState(() => trackFilePaths.value = sortedMusicFilePaths);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          PopupMenuButton(
            itemBuilder: (context) {
              List<VoidCallback> functions = [() {}, () {}, () {}];
              List<Text> textButtons = [
                const Text('Edit Tags'),
                const Text('Delete All'),
                const Text('Close')
              ];
              return List.generate(
                  2,
                  (index) => PopupMenuItem(
                        child: textButtons[index],
                        onTap: functions[index],
                      ));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Card(
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.20,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.height * 0.20,
                          child: widget.albumArt != null
                              ? Image.memory(
                                  widget.albumArt!,
                                )
                              : const Icon(
                                  CupertinoIcons.music_note,
                                  size: 100,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, top: 46),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 200, child: Text(widget.albumName)),
                              const Divider(
                                height: 1,
                              ),
                              Text(widget.albumArtist),
                              const Divider(
                                height: 1,
                              ),
                              Text('Tracks: ${widget.songs.length}')
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )),
          ),
          Expanded(
              child: TrackList(
            // musicTitles: widget.musicTitle,
            // trackArtists: widget.trackArtists,
            // trackDuration: widget.duration,
            currentTrack: currentTrackPath,
            playerState: playerState,
            musicFilePaths: widget.songs,
            singleTrackEnum: SingleTrackEnum.album,
          )),
          Player(
            musicFiles: widget.songs,
            screen: null,
            currentTrack: currentTrackPath,
            playerState: playerState,
          ),
        ],
      ),
    );
  }
}
