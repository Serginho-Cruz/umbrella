import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';

import 'income_type_factory.dart';

abstract class IncomeFactory {
  static final faker = Faker();

  static Income generate() => Income(
        id: faker.randomGenerator.integer(100),
        name: faker.lorem.word(),
        paymentDay: faker.date.dateTime(),
        type: IncomeTypeFactory.generate(),
        value: faker.randomGenerator.decimal(),
        personName: faker.person.firstName(),
        frequency: frequencyFromInt(faker.randomGenerator.integer(5, min: 0)),
      );
}
