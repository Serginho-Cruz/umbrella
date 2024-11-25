import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/adapt_name.dart';

import '../../../domain/models/status.dart';
import '../../utils/umbrella_palette.dart';
import '../../utils/umbrella_sizes.dart';

class StatusIcon extends StatelessWidget {
  const StatusIcon({super.key, required this.status, this.size = 30.0});

  final Status status;
  final double size;

  @override
  Widget build(BuildContext context) {
    Color iconBackgroundColor;
    IconData icon;

    switch (status) {
      case Status.okay:
        iconBackgroundColor = Colors.green.shade800;
        icon = Icons.check_rounded;
        break;
      case Status.inTime:
        iconBackgroundColor = Colors.orange.shade400;
        icon = Icons.access_time_rounded;
        break;
      case Status.overdue:
        iconBackgroundColor = Colors.red.shade400;
        icon = Icons.close_rounded;
        break;
    }

    return Tooltip(
      message: adaptStatusName(status),
      padding: const EdgeInsets.all(8),
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: UmbrellaSizes.small,
      ),
      decoration: BoxDecoration(
        color: UmbrellaPalette.primaryColor,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Material(
        color: iconBackgroundColor,
        shape: const CircleBorder(
          side: BorderSide(
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }
}
