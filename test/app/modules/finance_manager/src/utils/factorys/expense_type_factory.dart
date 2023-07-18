import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_type.dart';
import 'package:faker/faker.dart';

abstract class ExpenseTypeFactory {
  static ExpenseType generate() {
    return ExpenseType(
      id: faker.randomGenerator.integer(20),
      name: faker.lorem.word(),
      icon: faker.image.image(),
    );
  }
}
