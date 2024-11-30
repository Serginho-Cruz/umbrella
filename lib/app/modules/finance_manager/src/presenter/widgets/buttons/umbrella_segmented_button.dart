import 'package:flutter/material.dart';

import '../../utils/umbrella_palette.dart';

class UmbrellaSegmentedButton<T> extends StatelessWidget {
  const UmbrellaSegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
    this.isEmptyAllowed = false,
  });

  final List<ButtonSegment<T>> segments;
  final Set<T> selected;
  final void Function(Set<T>) onSelectionChanged;
  final bool isEmptyAllowed;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      segments: segments,
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      emptySelectionAllowed: isEmptyAllowed,
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 400),
        elevation: const WidgetStatePropertyAll(4.0),
        side: const WidgetStatePropertyAll(BorderSide(width: 1.0)),
        backgroundColor: WidgetStateProperty.resolveWith(
          (st) => st.contains(WidgetState.selected)
              ? UmbrellaPalette.filtersColor.withOpacity(0.5)
              : Colors.white,
        ),
      ),
    );
  }
}
