import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/datetime_extension.dart';

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
