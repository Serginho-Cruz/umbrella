import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/common/horizontal_infinity_container.dart';

abstract class BaseSelector<T> extends StatelessWidget {
  const BaseSelector({
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

  Widget _toucheableWidget(T item, BuildContext context) => InkWell(
        onTap: () {
          onItemTap(item);
          Navigator.pop(context);
        },
        child: itemBuilder(item),
      );
}

class GridSelector<T extends Object> extends BaseSelector<T> {
  const GridSelector({
    super.key,
    required super.items,
    required super.onItemTap,
    required super.itemBuilder,
    required super.child,
    required this.itemSize,
    this.itemsPerLine = 4,
    this.linesGap = 10.00,
  });

  final double itemSize;
  final int itemsPerLine;
  final double linesGap;

  @override
  Widget build(BuildContext context) {
    double availableSpace =
        MediaQuery.sizeOf(context).width - 40.0 - itemSize * itemsPerLine;

    int spaces = itemsPerLine - 1;

    double spaceBetweenItems = availableSpace / spaces;
    double space = spaceBetweenItems / 2;

    return InkWell(
      onTap: () {
        _showModalBottomSheet(
          context,
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: List.generate(
              (items.length / itemsPerLine).ceil(),
              (i) {
                var sublist = items
                    .sublist(itemsPerLine * i, _resolveEndIndex(i))
                    .indexed;

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: linesGap / 2),
                  child: Row(
                    children: sublist
                        .map(
                          (e) => Padding(
                            padding: _resolvePadding(
                              index: e.$1,
                              length: sublist.length,
                              space: space,
                            ),
                            child: super._toucheableWidget(e.$2, context),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),
          ),
        );
      },
      child: child,
    );
  }

  EdgeInsetsGeometry _resolvePadding({
    required int index,
    required int length,
    required double space,
  }) {
    //First Item in the list
    if (index == 0) return EdgeInsets.only(right: space);

    //Last Item in the list
    if (index == itemsPerLine - 1) return EdgeInsets.only(left: space);

    //Any other item
    return EdgeInsets.symmetric(horizontal: space);
  }

  int _resolveEndIndex(int i) {
    if (itemsPerLine * (i + 1) > items.length) {
      return items.length;
    }

    return itemsPerLine * (i + 1);
  }
}

class LinearSelector<T extends Object> extends BaseSelector<T> {
  const LinearSelector({
    super.key,
    required super.items,
    required super.onItemTap,
    required super.itemBuilder,
    required super.child,
    required this.title,
    this.direction = Axis.vertical,
  });

  final Widget? title;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    var widgetFunction =
        direction == Axis.vertical ? _columnSelector : _rowSelector;

    return InkWell(
      onTap: () {
        _showModalBottomSheet(
          context,
          widgetFunction(
            children: [
              for (var item in items)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: super._toucheableWidget(item, context),
                )
            ],
          ),
        );
      },
      child: child,
    );
  }

  Widget _columnSelector({required List<Widget> children}) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [if (title != null) title!, ...children],
      ),
    );
  }

  Widget _rowSelector({required List<Widget> children}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) title!,
        HorizontallyInfinityContainer(
          color: Colors.transparent,
          noShadow: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        ),
      ],
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
    constraints: BoxConstraints(
      minWidth: MediaQuery.of(context).size.width,
      maxWidth: double.infinity,
    ),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 25.0),
      child: child,
    ),
  );
}
