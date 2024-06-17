import 'package:flutter/material.dart';

class DialogLayout extends StatelessWidget {
  const DialogLayout({
    super.key,
    required this.child,
    this.fullscreen = false,
  });

  final Widget child;
  final bool fullscreen;

  @override
  Widget build(BuildContext context) {
    return fullscreen
        ? Dialog.fullscreen(
            backgroundColor: Colors.white,
            child: child,
          )
        : Dialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              side: const BorderSide(),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: child,
            ),
          );
  }
}
