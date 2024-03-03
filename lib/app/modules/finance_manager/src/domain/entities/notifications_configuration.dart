import 'package:equatable/equatable.dart';

class NotificationsConfiguration extends Equatable {
  final bool isToSend;
  final int daysBefore;
  final DateTime hourToSend;

  const NotificationsConfiguration({
    required this.isToSend,
    required this.daysBefore,
    required this.hourToSend,
  });

  NotificationsConfiguration copyWith({
    bool? isToSend,
    int? daysBefore,
    DateTime? hourToSend,
  }) {
    return NotificationsConfiguration(
      isToSend: isToSend ?? this.isToSend,
      daysBefore: daysBefore ?? this.daysBefore,
      hourToSend: hourToSend ?? this.hourToSend,
    );
  }

  @override
  List<Object?> get props => [
        isToSend,
        daysBefore,
        hourToSend,
      ];
}
