import 'package:flutter/material.dart';

class UniversalHeader extends StatefulWidget {
  const UniversalHeader({super.key});

  @override
  _UniversalHeaderState createState() => _UniversalHeaderState();
}

class _UniversalHeaderState extends State<UniversalHeader> {
  double _scrollOffset = 0;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _UniversalHeaderDelegate(scrollOffset: _scrollOffset),
    );
  }
}

class _UniversalHeaderDelegate extends SliverPersistentHeaderDelegate {
  _UniversalHeaderDelegate({required this.scrollOffset});

  final double scrollOffset;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: shrinkOffset > 200 ? 0 : 1,
          duration: Duration(milliseconds: 100),
          child: Container(
            height: 200,
            color: Colors.blue,
            child: Center(
              child: Text(
                'This is the universal header',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          top: shrinkOffset > 200 ? 100 : 0,
          left: 0,
          right: 0,
          duration: const Duration(milliseconds: 500),
          child: AnimatedOpacity(
            opacity: shrinkOffset > 200 ? 0 : 1,
            duration: Duration(milliseconds: 100),
            child: Container(
              height: 50,
              color: Colors.red,
              child: Center(
                child: Text(
                  'This is the search bar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return scrollOffset !=
        oldDelegate.stretchConfiguration!.stretchTriggerOffset;
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => throw UnimplementedError();

  @override
  // TODO: implement minExtent
  double get minExtent => throw UnimplementedError();
}
