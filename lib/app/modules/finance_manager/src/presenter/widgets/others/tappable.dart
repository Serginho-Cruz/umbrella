import 'package:flutter/material.dart';

import '../../utils/umbrella_palette.dart';
import '../texts/medium_text.dart';

enum TappableDispatcher { tap, doubleTap }

class Tappable extends StatefulWidget {
  const Tappable({
    super.key,
    required this.child,
    required this.options,
    this.openMenuDispatcher = TappableDispatcher.tap,
  });

  final Widget child;
  final List<({String name, VoidCallback onPressed})> options;
  final TappableDispatcher openMenuDispatcher;

  @override
  State<Tappable> createState() => _TappableState();
}

class _TappableState extends State<Tappable> {
  late final MenuController _menuController;

  @override
  void initState() {
    super.initState();

    _menuController = MenuController();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: const MenuStyle(
        alignment: Alignment.center,
        side: WidgetStatePropertyAll(BorderSide()),
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        elevation: WidgetStatePropertyAll(4.0),
        padding: WidgetStatePropertyAll(EdgeInsets.all(8.0)),
      ),
      controller: _menuController,
      menuChildren: widget.options.map(
        (option) {
          return MenuItemButton(
            style: ButtonStyle(
              minimumSize: const WidgetStatePropertyAll(Size(180, 50.0)),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.any((state) =>
                    state == WidgetState.pressed ||
                    state == WidgetState.hovered)) {
                  return Colors.white;
                }

                return UmbrellaPalette.gray;
              }),
            ),
            onPressed: option.onPressed,
            child: MediumText(option.name, fontWeight: FontWeight.normal),
          );
        },
      ).toList(),
      child: GestureDetector(
        onTap: widget.openMenuDispatcher == TappableDispatcher.tap
            ? _toggleMenu
            : null,
        onDoubleTap: widget.openMenuDispatcher == TappableDispatcher.doubleTap
            ? _toggleMenu
            : null,
        child: widget.child,
      ),
    );
  }

  void _toggleMenu() {
    if (_menuController.isOpen) {
      _menuController.close();
    } else {
      _menuController.open();
    }
  }
}
