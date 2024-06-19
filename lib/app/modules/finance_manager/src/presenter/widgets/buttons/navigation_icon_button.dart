import 'package:flutter/material.dart';

import '../../../utils/umbrella_palette.dart';

class NavigationIconButton extends StatelessWidget {
  const NavigationIconButton({
    super.key,
    required this.route,
    this.backgroundColor = UmbrellaPalette.actionButtonColor,
    this.hoverColor = UmbrellaPalette.activePrimaryButton,
    this.icon = const Icon(
      Icons.add,
      color: Colors.white,
      size: 40.0,
    ),
    this.width = 60.0,
    this.height = 60.0,
  });

  final double width;
  final double height;
  final String route;
  final Color backgroundColor;
  final Color hoverColor;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      elevation: 4.0,
      shape: const CircleBorder(side: BorderSide(width: 2.0)),
      child: IconButton(
        icon: icon,
        constraints: BoxConstraints(
          minWidth: width,
          minHeight: height,
          maxWidth: width,
          maxHeight: height,
        ),
        hoverColor: hoverColor,
        onPressed: () {
          Navigator.of(context).pushNamed(route);
        },
      ),
    );
  }
}
