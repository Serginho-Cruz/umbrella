import 'package:flutter/material.dart';

import '../texts/big_text.dart';
import '../texts/medium_text.dart';
import 'base_selectors.dart';

class DaySelector extends StatelessWidget {
  const DaySelector({
    super.key,
    this.bottomSheetText = 'Selecione o Dia',
    required this.onDaySelected,
    required this.child,
  });

  final String bottomSheetText;
  final void Function(int) onDaySelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    //Change it to a table format. Like DatePicker. Rename to DayPicker also
    return LinearSelector<int>(
      items: List.generate(31, (i) => i + 1),
      direction: Axis.horizontal,
      itemBuilder: (day) {
        return Container(
          width: 50.0,
          height: 50.0,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(),
            color: Colors.white,
          ),
          child: Center(
            child: MediumText(day.toString()),
          ),
        );
      },
      onItemTap: onDaySelected,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: BigText(bottomSheetText, textAlign: TextAlign.center),
      ),
      child: child,
    );
  }
}
