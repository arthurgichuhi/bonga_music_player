import 'package:bonga_music/theme.dart';
import 'package:flutter/material.dart';

class ResourcesNavigation extends StatelessWidget {
  const ResourcesNavigation(
      {super.key, required this.button_name, required this.on_pressed});
  final String button_name;
  final VoidCallback on_pressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: on_pressed,
        borderRadius: BorderRadius.circular(6),
        splashColor: AppColors.secondary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            button_name,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
