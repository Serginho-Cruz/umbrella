import 'package:flutter/material.dart';

class HorizontalAnimatedList extends StatefulWidget {
  const HorizontalAnimatedList({
    super.key,
    required this.itemBuilderFunction,
    required this.length,
    required this.animatedListKey,
  });

  final Widget Function(BuildContext, int) itemBuilderFunction;
  final GlobalKey<AnimatedListState> animatedListKey;
  final int length;

  @override
  State<HorizontalAnimatedList> createState() => _HorizontalAnimatedListState();
}

class _HorizontalAnimatedListState extends State<HorizontalAnimatedList> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      widget.animatedListKey.currentState!.insertItem(0);
    });

    if (widget.length > 1) {
      var future = Future(() {});
      for (int i = 1; i < widget.length; i++) {
        future = future.then((_) {
          return Future.delayed(const Duration(milliseconds: 750), () {
            widget.animatedListKey.currentState!.insertItem(i);
          });
        });
      }
    }

    return AnimatedList(
      key: widget.animatedListKey,
      initialItemCount: 0,
      padding: const EdgeInsets.symmetric(
        vertical: 40.0,
      ),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index, animation) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: const Interval(
              0.0,
              0.5,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: SlideTransition(
            position: CurvedAnimation(
              curve: Curves.easeInOut,
              parent: animation,
            ).drive((Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: const Offset(0.0, 0.0),
            ))),
            child: widget.itemBuilderFunction(context, index),
          ),
        );
      },
    );
  }
}
