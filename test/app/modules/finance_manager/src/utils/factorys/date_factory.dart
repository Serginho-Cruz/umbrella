import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

abstract class DateFactory {
  static Date generate({int? day, int? month, int? year}) {
    return Date(
      day: day ?? faker.randomGenerator.integer(31, min: 1),
      month: month ?? faker.randomGenerator.integer(12, min: 1),
      year: faker.randomGenerator.integer(2030, min: 2023),
    );
  }
}
