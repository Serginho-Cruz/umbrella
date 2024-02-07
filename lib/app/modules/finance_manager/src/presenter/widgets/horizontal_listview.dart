import 'package:flutter/material.dart';

class HorizontalListView extends StatelessWidget {
  const HorizontalListView({
    super.key,
    required this.itemCallback,
    required this.itemCount,
  });

  final Widget Function(int) itemCallback;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        vertical: 40.0,
      ),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => itemCallback(index),
    );
  }
}
