import 'package:flutter/material.dart';

import '../../../domain/entities/date.dart';
import '../../utils/umbrella_sizes.dart';
import '../buttons/umbrella_icon_button.dart';

class DateRangeFilter extends StatelessWidget {
  const DateRangeFilter({
    super.key,
    required this.minDate,
    required this.maxDate,
    required this.month,
    required this.year,
    required this.onChanged,
  });

  final Date minDate;
  final Date maxDate;
  final void Function(Date newMin, Date newMax) onChanged;

  final int month;
  final int year;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: UmbrellaSizes.big,
              color: Colors.black,
            ),
            children: [
              const TextSpan(text: 'Desde o '),
              TextSpan(
                text: 'dia ${minDate.day}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ' até o '),
              TextSpan(
                text: 'dia ${maxDate.day}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        UmbrellaIconButton(
          isPrimary: true,
          icon: const Icon(Icons.calendar_month),
          onPressed: () {
            showDateRangePicker(
              context: context,
              firstDate: DateTime(year, month, 1),
              lastDate: DateTime(
                year,
                month,
                Date.totalDaysOnMonth(month, year),
              ),
              initialDateRange: DateTimeRange(
                start: minDate.toDateTime(),
                end: maxDate.toDateTime(),
              ),
            ).then((range) {
              if (range != null) {
                onChanged(
                  Date.fromDateTime(range.start),
                  Date.fromDateTime(range.end),
                );
              }
            });
          },
        ),
      ],
    );
  }
}
