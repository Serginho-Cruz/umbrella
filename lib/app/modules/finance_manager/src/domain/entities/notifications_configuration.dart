// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

class NotificationsConfiguration extends Equatable {
  final bool isToSend;
  final int daysBefore;
  final Date hourToSend;

  const NotificationsConfiguration({
    required this.isToSend,
    required this.daysBefore,
    required this.hourToSend,
  });

  NotificationsConfiguration copyWith({
    bool? isToSend,
    int? daysBefore,
    Date? hourToSend,
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
