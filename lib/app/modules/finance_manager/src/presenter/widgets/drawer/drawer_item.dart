import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final Icon icon;
  final String route;

  const DrawerItem({
    super.key,
    required this.title,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: icon,
      style: ListTileStyle.drawer,
      onTap: () {
        Navigator.of(context).pushReplacementNamed(route);
      },
    );
  }
}
