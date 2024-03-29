import 'package:flutter/material.dart';

abstract class Selector<T> extends StatelessWidget {
  const Selector({
    super.key,
    required this.items,
    required this.onItemTap,
    required this.itemBuilder,
    required this.child,
  });

  final List<T> items;
  final void Function(T) onItemTap;
  final Widget Function(T) itemBuilder;
  final Widget child;
}

class RadialSelector<T extends Object> extends Selector<T> {
  const RadialSelector({
    super.key,
    required super.items,
    required super.onItemTap,
    required super.itemBuilder,
    required super.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showModalBottomSheet(
          context,
          ListView.builder(
            itemCount: items.length ~/ 4 + 1,
            itemBuilder: (ctx, number) {
              return Row(
                children: [
                  for (var item in items.sublist(
                      number, number + 3 > items.length ? null : number + 3))
                    GestureDetector(
                      onTap: () {
                        onItemTap(item);
                        Navigator.pop(context);
                      },
                      child: itemBuilder(item),
                    ),
                ],
              );
            },
          ),
        );
      },
      child: child,
    );
  }
}

class LinearSelector<T extends Object> extends Selector<T> {
  const LinearSelector({
    super.key,
    required super.items,
    required super.onItemTap,
    required super.itemBuilder,
    required super.child,
    this.title,
  });

  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showModalBottomSheet(
          context,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) title!,
              for (var item in items)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    onTap: () {
                      onItemTap(item);
                      Navigator.pop(context);
                    },
                    child: itemBuilder(item),
                  ),
                )
            ],
          ),
        );
      },
      child: child,
    );
  }
}

_showModalBottomSheet(
  BuildContext context,
  Widget child,
) {
  showModalBottomSheet(
    context: context,
    elevation: 12.0,
    constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 25.0),
      child: child,
    ),
  );
}
