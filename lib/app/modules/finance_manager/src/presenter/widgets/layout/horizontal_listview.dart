import 'package:flutter/material.dart';

class HorizontalListView extends StatelessWidget {
  const HorizontalListView({
    super.key,
    required this.itemCallback,
    required this.itemCount,
    this.padding = EdgeInsets.zero,
  });

  final Widget Function(int) itemCallback;
  final EdgeInsetsGeometry padding;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      physics: const BouncingScrollPhysics(),
      padding: padding,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => itemCallback(index),
    );
  }
}
