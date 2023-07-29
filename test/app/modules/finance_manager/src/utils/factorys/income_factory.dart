import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_type.dart';

import 'frequency_factory.dart';
import 'income_type_factory.dart';

abstract class IncomeFactory {
  static Income generate({String? name, IncomeType? type, double? value}) {
    return Income(
      id: faker.randomGenerator.integer(20),
      name: name ?? faker.lorem.word(),
      value: value ?? faker.randomGenerator.decimal() * 500,
      paymentDate: faker.date.dateTime(minYear: 2023, maxYear: 2025),
      frequency: FrequencyFactory.generate(),
      type: type ?? IncomeTypeFactory.generate(),
      personName:
          faker.randomGenerator.boolean() ? null : faker.person.firstName(),
      dueDate: faker.date.dateTime(minYear: 2023, maxYear: 2025),
    );
  }
}
