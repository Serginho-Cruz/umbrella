import 'package:flutter/material.dart';

import '../drawer/my_drawer.dart';

class UmbrellaScaffold extends StatelessWidget {
  const UmbrellaScaffold({
    super.key,
    this.floatingActionButton,
    required this.child,
    required this.appBar,
  });

  final Widget child;
  final PreferredSizeWidget appBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        backgroundColor: Colors.white,
        appBar: appBar,
        body: child,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
