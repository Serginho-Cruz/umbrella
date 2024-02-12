import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_type.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';

import 'date_factory.dart';
import 'expense_type_factory.dart';
import 'frequency_factory.dart';

abstract class ExpenseFactory {
  static Expense generate({
    int? id,
    String? name,
    ExpenseType? type,
    Frequency? frequency,
    double? value,
    Date? dueDate,
    String? personName,
  }) {
    return Expense(
      id: id ?? faker.randomGenerator.integer(20),
      value: value ?? faker.randomGenerator.decimal(scale: 1000),
      name: name ?? faker.lorem.word(),
      dueDate: dueDate ?? DateFactory.generate(),
      type: type ?? ExpenseTypeFactory.generate(),
      frequency: frequency ?? FrequencyFactory.generate(),
      personName: personName ??
          (faker.randomGenerator.boolean() ? faker.person.name() : null),
    );
  }
}
