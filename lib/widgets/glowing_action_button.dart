import 'package:bonga_music/repositories/musicFilePathsProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './../theme.dart';

class GlowingActionButton extends ConsumerWidget {
  const GlowingActionButton({
    Key? key,
    required this.color,
    required this.icon,
    this.size = 54,
    required this.onPressed,
  }) : super(key: key);

  const GlowingActionButton.small(
      {super.key,
      required this.color,
      required this.icon,
      required this.onPressed})
      : size = 43;

  final Color color;
  final IconData icon;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration:
          BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
        BoxShadow(
            color: color.withOpacity(0.3),
            spreadRadius: 10,
            blurRadius: 24,
            offset: const Offset(-22, 0)),
        BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 24,
            offset: const Offset(22, 0)),
        BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 8,
            blurRadius: 42,
            offset: const Offset(-22, 0)),
        BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 8,
            blurRadius: 42,
            offset: const Offset(22, 0))
      ]),
      child: ClipOval(
        child: Material(
          color: color,
          child: InkWell(
            splashColor: AppColors.cardLight,
            onTap: onPressed,
            child: SizedBox(
              width: size,
              height: size,
              child: icon != Icons.repeat
                  ? Icon(
                      icon,
                      size: 26,
                      color: Colors.white,
                    )
                  : ref.watch(loopingStatusProvider) == 0
                      ? Icon(icon)
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              icon,
                              color: Colors.white,
                              size: 28,
                            ),
                            Text(
                              ref.watch(loopingStatusProvider) == 1
                                  ? ref.watch(loopingStatusProvider).toString()
                                  : '',
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
