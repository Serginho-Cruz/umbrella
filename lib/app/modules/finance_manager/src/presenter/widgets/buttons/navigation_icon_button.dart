import 'package:flutter/material.dart';

import '../../utils/umbrella_palette.dart';

class NavigationIconButton extends StatelessWidget {
  const NavigationIconButton({
    super.key,
    required this.route,
    required this.tooltipMessage,
    this.backgroundColor = UmbrellaPalette.actionButtonColor,
    this.hoverColor = UmbrellaPalette.activePrimaryButton,
    this.icon = const Icon(
      Icons.add,
      color: Colors.black,
      size: 30.0,
    ),
    this.onPop,
  });

  final String route;
  final Color backgroundColor;
  final Color hoverColor;
  final Icon icon;
  final String tooltipMessage;

  final VoidCallback? onPop;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      elevation: 4.0,
      shape: const CircleBorder(side: BorderSide(width: 2.0)),
      child: IconButton(
        tooltip: tooltipMessage,
        icon: icon,
        hoverColor: hoverColor,
        onPressed: () {
          Navigator.of(context).pushNamed(route).then((_) {
            onPop?.call();
          });
        },
      ),
    );
  }
}
