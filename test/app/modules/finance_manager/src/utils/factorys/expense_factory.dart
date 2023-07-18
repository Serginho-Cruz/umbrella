import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_type.dart';

import 'expense_type_factory.dart';
import 'frequency_factory.dart';

abstract class ExpenseFactory {
  static Expense generate({String? name, ExpenseType? type}) {
    return Expense(
      id: faker.randomGenerator.integer(20),
      value: faker.randomGenerator.decimal(scale: 1000),
      name: name ?? faker.lorem.word(),
      dueDate: faker.date.dateTime(minYear: 2025, maxYear: 2025),
      type: type ?? ExpenseTypeFactory.generate(),
      frequency: FrequencyFactory.generate(),
      personName: faker.randomGenerator.boolean() ? faker.person.name() : null,
    );
  }
}
