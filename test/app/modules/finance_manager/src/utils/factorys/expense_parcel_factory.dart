import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_type.dart';

import 'date_factory.dart';
import 'expense_factory.dart';

abstract class ExpenseParcelFactory {
  static ExpenseParcel generate({
    int? id,
    String? name,
    ExpenseType? type,
    double? paidValue,
    Date? paymentDate,
    Date? dueDate,
    double? totalValue,
    Expense? expense,
  }) {
    //generate a string that contains the name if passed,
    //in begin, middle or final of the string
    var finalName = name == null
        ? null
        : faker.randomGenerator.boolean()
            ? '$name ${faker.lorem.word()}'
            : faker.randomGenerator.boolean()
                ? '${faker.lorem.word()} $name ${faker.lorem.word()}'
                : '${faker.lorem.word()} $name';

    paidValue = paidValue ?? faker.randomGenerator.decimal() * 500;
    totalValue =
        totalValue ?? faker.randomGenerator.decimal(min: paidValue + 0.1);

    return ExpenseParcel(
      id: id ?? faker.randomGenerator.integer(20),
      expense: expense ?? ExpenseFactory.generate(name: finalName, type: type),
      dueDate: dueDate ?? DateFactory.generate(),
      paidValue: paidValue,
      remainingValue: totalValue - paidValue,
      paymentDate: paymentDate ??
          (faker.randomGenerator.boolean() ? DateFactory.generate() : null),
      totalValue: totalValue,
    );
  }

  static ExpenseParcel generatePaidParcel() {
    var expense = ExpenseFactory.generate();
    return ExpenseParcel(
      expense: expense,
      dueDate: DateFactory.generate(),
      id: faker.randomGenerator.integer(20),
      paidValue: expense.value,
      remainingValue: expense.value - expense.value,
      paymentDate: DateFactory.generate(),
      totalValue: expense.value,
    );
  }
}
