import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_type.dart';
import 'package:faker/faker.dart';

abstract class IncomeTypeFactory {
  static final faker = Faker();
  static IncomeType generate() => IncomeType(
        id: faker.randomGenerator.integer(20),
        name: faker.lorem.word(),
        icon: faker.randomGenerator.string(20),
      );
}
