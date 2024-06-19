import 'package:flutter/material.dart';

import '../../../domain/models/status.dart';
import '../texts/medium_text.dart';

class PaiyableStatusFilter extends StatelessWidget {
  const PaiyableStatusFilter({
    super.key,
    required this.status,
    this.selectedStatus = const [],
    required this.onStatusChanged,
  });

  final List<Status> status;
  final List<Status> selectedStatus;

  final void Function(Status) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: status
          .map(
            (s) => Row(
              children: [
                Checkbox.adaptive(
                  value: selectedStatus.contains(s),
                  onChanged: (_) {
                    onStatusChanged(s);
                  },
                ),
                MediumText(s.adaptedName),
              ],
            ),
          )
          .toList(),
    );
  }
}
