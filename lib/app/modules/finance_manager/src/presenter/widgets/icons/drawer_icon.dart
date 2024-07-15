import 'package:flutter/material.dart';

class DrawerIcon extends StatelessWidget {
  const DrawerIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Scaffold.maybeOf(context)?.openDrawer();
      },
      icon: const Icon(
        Icons.menu_rounded,
        color: Colors.black,
        size: 35.0,
      ),
    );
  }
}
