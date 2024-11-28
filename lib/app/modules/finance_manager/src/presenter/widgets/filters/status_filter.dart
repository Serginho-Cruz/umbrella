import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../domain/models/status.dart';
import '../texts/medium_text.dart';

class StatusFilter extends StatelessWidget {
  const StatusFilter({
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
    return Observer(
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: status
            .map(
              (s) => GestureDetector(
                onTap: () => onStatusChanged(s),
                child: Row(
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
              ),
            )
            .toList(),
      ),
    );
  }
}
