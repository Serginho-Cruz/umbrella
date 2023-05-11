import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_type.dart';

abstract class ExpenseTypeFactory {
  static final Faker faker = Faker();

  static ExpenseType generate() => ExpenseType(
        id: faker.randomGenerator.integer(20),
        name: faker.lorem.word(),
        icon: faker.lorem.word(),
      );
}
