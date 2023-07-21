import 'package:equatable/equatable.dart';

import '../../utils/extensions.dart';

class NotificationsConfiguration extends Equatable {
  final bool isToSend;
  final int daysBefore;
  final DateTime hourToSend;

  const NotificationsConfiguration({
    required this.isToSend,
    required this.daysBefore,
    required this.hourToSend,
  });

  @override
  List<Object?> get props => [
        isToSend,
        daysBefore,
        hourToSend.time,
      ];
}
