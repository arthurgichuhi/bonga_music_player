import 'package:flutter/cupertino.dart';

class SingleTrack extends StatelessWidget {
  const SingleTrack(
      {super.key,
      required this.currentTrack,
      required this.myTrackPath,
      required this.trackTitle,
      required this.trackArtist});
  final ValueNotifier<String> currentTrack;
  final String myTrackPath;
  final String trackTitle;
  final String trackArtist;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(children: [
        Icon(currentTrack.value != myTrackPath
            ? CupertinoIcons.play
            : CupertinoIcons.pause),
        Column(
          children: [Text(trackTitle), Text(trackArtist)],
        )
      ]),
    );
  }
}
