import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_type.dart';

abstract class IncomeTypeFactory {
  static IncomeType generate() {
    return IncomeType(
      id: faker.randomGenerator.integer(20),
      name: faker.lorem.word(),
      icon: faker.image.image(),
    );
  }
}
