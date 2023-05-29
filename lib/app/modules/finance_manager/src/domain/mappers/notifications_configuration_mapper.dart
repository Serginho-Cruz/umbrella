import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/notifications_configuration_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/datetime_extension.dart';

import '../entities/notifications_configuration.dart';

abstract class NotificationsConfigurationMapper {
  static Map<String, dynamic> toMap(NotificationsConfiguration configuration) =>
      <String, dynamic>{
        NotificationsConfigurationTable.daysBefore: configuration.daysBefore,
        NotificationsConfigurationTable.hourToSend:
            configuration.hourToSend.time,
        NotificationsConfigurationTable.isToSend: configuration.isToSend
      };

  static NotificationsConfiguration fromMap(Map<String, dynamic> map) {
    var hourToSend = map[NotificationsConfigurationTable.hourToSend] as String;

    return NotificationsConfiguration(
      isToSend: map[NotificationsConfigurationTable.isToSend] as bool,
      daysBefore: map[NotificationsConfigurationTable.daysBefore] as int,
      hourToSend: DateTime.parse('20230203 $hourToSend'),
    );
  }
}
