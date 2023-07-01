import 'package:equatable/equatable.dart';

import '../../utils/extensions.dart';

class NotificationsConfiguration with EquatableMixin {
  bool isToSend;
  int daysBefore;
  DateTime hourToSend;

  NotificationsConfiguration({
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
