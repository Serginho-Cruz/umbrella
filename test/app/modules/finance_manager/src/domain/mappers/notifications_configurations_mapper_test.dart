import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/mappers/notifications_configuration_mapper.dart';

import '../../utils/entities.dart';
import '../../utils/maps.dart';

void main() {
  test("To Map Method is Working", () {
    var result =
        NotificationsConfigurationMapper.toMap(notificationsConfiguration);

    expect(result, equals(notificationsMap));
  });
  test("From Map Method is Working", () {
    var result = NotificationsConfigurationMapper.fromMap(notificationsMap);

    expect(result, equals(notificationsConfiguration));
  });
}
