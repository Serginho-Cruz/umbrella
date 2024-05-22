import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/umbrella_sizes.dart';

import '../../../domain/entities/date.dart';

sealed class CustomDatePickerDialog {
  static Future<Date?> show(
    BuildContext context, {
    required Date initialDate,
  }) async {
    Date? date = await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          elevation: 8.0,
          child: _CustomDatePicker(initialDate: initialDate),
        );
      },
    );
    return date;
  }
}

class _CustomDatePicker extends StatefulWidget {
  const _CustomDatePicker({
    required this.initialDate,
  });

  final Date initialDate;

  @override
  State<_CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<_CustomDatePicker> {
  late Date selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 10.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide()),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selecione a Data',
                    style: TextStyle(fontSize: UmbrellaSizes.small),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    _formatInLongForm(selectedDate),
                    style: const TextStyle(fontSize: UmbrellaSizes.big),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          CalendarDatePicker(
            initialDate: selectedDate.toDateTime(),
            firstDate: Date.today().subtract(years: 5).toDateTime(),
            lastDate: Date.today().add(years: 5).toDateTime(),
            onDateChanged: (newDate) {
              setState(() {
                selectedDate = Date.fromDateTime(newDate);
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Confirmar'),
                onPressed: () {
                  Navigator.pop(context, selectedDate);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  String _formatInLongForm(Date date) {
    return '${date.day} de ${date.monthName} de ${date.year}';
  }
}
