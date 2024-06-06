import 'package:flutter/material.dart';

class HorizontalAnimatedList extends StatefulWidget {
  const HorizontalAnimatedList({
    super.key,
    required this.itemBuilderFunction,
    required this.length,
  });

  final Widget Function(BuildContext, int) itemBuilderFunction;
  final int length;

  @override
  State<HorizontalAnimatedList> createState() => _HorizontalAnimatedListState();
}

class _HorizontalAnimatedListState extends State<HorizontalAnimatedList> {
  late final GlobalKey<AnimatedListState> _key;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      _key.currentState!.removeAllItems(
          (context, animation) => SizeTransition(sizeFactor: animation));
      _key.currentState!.insertAllItems(0, widget.length,
          duration: const Duration(milliseconds: 1200));
    });
    return AnimatedList(
      key: _key,
      initialItemCount: 0,
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index, animation) {
        return ScaleTransition(
          scale:
              CurvedAnimation(parent: animation, curve: Curves.linearToEaseOut),
          child: widget.itemBuilderFunction(context, index),
        );
      },
    );
  }
}
