import 'package:flutter/material.dart';

import '../../../domain/entities/date.dart';
import '../dialogs/date_picker_dialog.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  final Date initialDate;
  final void Function(Date) onDateSelected;

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late Date selectedDate;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    _controller.text = selectedDate.toString(format: DateFormat.ddmmyyyy);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Data de Vencimento',
          prefixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        readOnly: true,
        onTap: () {
          CustomDatePickerDialog.show(context, initialDate: selectedDate)
              .then((date) {
            if (date != null) {
              setState(() {
                selectedDate = date;
                _controller.text =
                    selectedDate.toString(format: DateFormat.ddmmyyyy);
              });
              widget.onDateSelected(date);
            }
          });
        },
      ),
    );
  }
}
