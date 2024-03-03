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
    double? totalValue,
    double? paidValue,
    double? remainingValue,
    Date? paymentDate,
    Date? dueDate,
    String? personName,
  }) {
    var total = totalValue ?? faker.randomGenerator.decimal(scale: 1000);
    var paid = paidValue ?? faker.randomGenerator.decimal(scale: total);

    return Expense(
      id: id ?? faker.randomGenerator.integer(20),
      totalValue: total,
      paidValue: paid,
      remainingValue: total - paid,
      name: name ?? faker.lorem.word(),
      dueDate: dueDate ?? DateFactory.generate(),
      paymentDate: paymentDate ??
          (faker.randomGenerator.boolean() ? DateFactory.generate() : null),
      type: type ?? ExpenseTypeFactory.generate(),
      frequency: frequency ?? FrequencyFactory.generate(),
      personName: personName ??
          (faker.randomGenerator.boolean() ? faker.person.name() : null),
    );
  }

  static Expense generatePaid() {
    var value = faker.randomGenerator.decimal(min: 25.0, scale: 1000);
    return Expense(
      id: faker.randomGenerator.integer(20),
      name: faker.randomGenerator.string(25),
      totalValue: value,
      paidValue: value,
      remainingValue: 0,
      dueDate: DateFactory.generate(),
      paymentDate: DateFactory.generate(),
      type: ExpenseTypeFactory.generate(),
      frequency: FrequencyFactory.generate(),
    );
  }
}
