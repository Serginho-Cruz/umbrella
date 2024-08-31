import 'package:flutter/material.dart';

class HorizontalAnimatedList extends StatefulWidget {
  const HorizontalAnimatedList({
    super.key,
    required this.itemBuilderFunction,
    required this.length,
    required this.height,
  });

  final Widget Function(BuildContext, int) itemBuilderFunction;
  final int length;
  final double height;

  @override
  State<HorizontalAnimatedList> createState() => _HorizontalAnimatedListState();
}

class _HorizontalAnimatedListState extends State<HorizontalAnimatedList> {
  late final GlobalKey<AnimatedListState> _key;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _key.currentState!.removeAllItems(
          (context, animation) => SizeTransition(sizeFactor: animation));
      _key.currentState!.insertAllItems(0, widget.length,
          duration: const Duration(milliseconds: 1200));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: AnimatedList(
        key: _key,
        initialItemCount: 0,
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index, animation) {
          return ScaleTransition(
            scale: CurvedAnimation(
                parent: animation, curve: Curves.linearToEaseOut),
            child: widget.itemBuilderFunction(context, index),
          );
        },
      ),
    );
  }
}
