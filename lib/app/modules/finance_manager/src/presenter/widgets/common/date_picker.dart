import 'package:flutter/material.dart';

import '../../../domain/entities/date.dart';
import 'date_picker_dialog.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  final Date initialDate;
  final void Function(Date) onDateSelected;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late Date selectedDate;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    _controller.text = selectedDate.toString(format: DateFormat.ddmmyyyy);
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
          // showDatePicker(
          //   context: context,
          //   initialDate: widget.initialDate.toDateTime(),
          //   firstDate: Date.today().subtract(years: 5).toDateTime(),
          //   lastDate: Date.today().add(years: 5).toDateTime(),
          //   cancelText: 'Cancelar',
          //   confirmText: 'Confirmar',
          //   helpText: 'Selecione a Data',
          // ).then((date) {
          //   if (date != null) {
          //     Date newDate = (Date.fromDateTime(date));

          //     setState(() {
          //       selectedDate = newDate;
          //       _controller.text =
          //           selectedDate.toString(format: DateFormat.ddmmyyyy);
          //     });
          //     widget.onDateSelected(newDate);
          //   }
          // });
        },
      ),
    );
  }
}
