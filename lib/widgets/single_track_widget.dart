import 'package:bonga_music/theme.dart';
import 'package:flutter/material.dart';

import '../screen/music_resources.dart';

class SingleTrack extends StatefulWidget {
  const SingleTrack(
      {super.key,
      required this.currentTrack,
      required this.playerState,
      required this.myTrackPath,
      required this.trackTitle,
      required this.trackArtist,
      required this.musicFiles});
  final ValueNotifier<String> currentTrack;
  final ValueNotifier<bool> playerState;
  final String myTrackPath;
  final String trackTitle;
  final String trackArtist;
  final List<String> musicFiles;

  @override
  State<SingleTrack> createState() => _SingleTrackState();
}

class _SingleTrackState extends State<SingleTrack> {
  // ValueNotifier<String> currentTrack = ValueNotifier('');
  @override
  void initState() {
    valueChangeListener();
    super.initState();

    // valueChangeListener();
  }

  valueChangeListener() {
    currentTrackPath.addListener(() {
      debugPrint(
          'single track .........................${widget.currentTrack.value}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          widget.currentTrack.value = widget.myTrackPath;
          widget.playerState.value = true;
          trackFilePaths.value = widget.musicFiles;
        },
        child: SizedBox(
          child: Row(children: [
            // Icon(currentTrackPath.value != widget.myTrackPath
            //     ? CupertinoIcons.play
            //     : widget.playerState.value
            //         ? CupertinoIcons.pause
            //         : CupertinoIcons.play),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  minHeight: MediaQuery.of(context).size.height * .055),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.trackTitle,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: currentTrackPath.value == widget.myTrackPath
                            ? AppColors.accent
                            : null),
                  ),
                  // const Divider(
                  //   height: 2,
                  // ),
                  Text(widget.trackArtist)
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
