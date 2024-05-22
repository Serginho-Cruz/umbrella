import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/common/horizontal_infinity_container.dart';

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
          GridView.count(
            crossAxisCount: (items.length / 4).ceil(),
            children: List.generate(
              items.length,
              (i) => InkWell(
                onTap: () {
                  onItemTap(items[i]);
                  Navigator.pop(context);
                },
                child: itemBuilder(items[i]),
              ),
            ),
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
