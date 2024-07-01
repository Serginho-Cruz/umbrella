import 'package:flutter/material.dart';

import '../../../domain/entities/date.dart';
import '../dialogs/date_picker_dialog.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({
    super.key,
    required this.date,
    required this.onDateSelected,
    this.label = 'Data de Vencimento',
  });

  final Date date;
  final void Function(Date) onDateSelected;
  final String label;

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    setDate();
    super.initState();
  }

  void setDate() {
    controller.text = widget.date.toString(format: DateFormat.ddmmyyyy);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        readOnly: true,
        onTap: () {
          CustomDatePickerDialog.show(context, initialDate: widget.date)
              .then((newDate) {
            if (newDate != null) {
              widget.onDateSelected(newDate);
            }
          });
        },
      ),
    );
  }

  @override
  void didUpdateWidget(covariant DateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    setDate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
