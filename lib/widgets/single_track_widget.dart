import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleTrack extends StatefulWidget {
  const SingleTrack(
      {super.key,
      required this.currentTrack,
      required this.playerState,
      required this.myTrackPath,
      required this.trackTitle,
      required this.trackArtist});
  final ValueNotifier<String> currentTrack;
  final ValueNotifier<bool> playerState;
  final String myTrackPath;
  final String trackTitle;
  final String trackArtist;

  @override
  State<SingleTrack> createState() => _SingleTrackState();
}

class _SingleTrackState extends State<SingleTrack> {
  // ValueNotifier<String> currentTrack = ValueNotifier('');
  @override
  void initState() {
    valueChangeListener();
    super.initState();

    valueChangeListener();
  }

  valueChangeListener() {
    widget.currentTrack.addListener(() {
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
        },
        child: SizedBox(
          child: Row(children: [
            Icon(widget.currentTrack.value != widget.myTrackPath
                ? CupertinoIcons.play
                : widget.playerState.value
                    ? CupertinoIcons.pause
                    : CupertinoIcons.play),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.trackTitle),
                const Divider(
                  height: 2,
                ),
                Text(widget.trackArtist)
              ],
            )
          ]),
        ),
      ),
    );
  }
}
