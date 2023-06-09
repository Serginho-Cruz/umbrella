import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/notifications_configuration.dart';

abstract class NotificationsFactory {
  static final faker = Faker();

  static NotificationsConfiguration generate() => NotificationsConfiguration(
        isToSend: faker.randomGenerator.boolean(),
        daysBefore: faker.randomGenerator.integer(15),
        hourToSend: faker.date.dateTime(minYear: 2022, maxYear: 2023),
      );

  static NotificationsConfiguration generateDefault() =>
      NotificationsConfiguration(
        isToSend: true,
        daysBefore: 7,
        hourToSend: DateTime(2023, 2, 3, 20, 00),
      );
}
