import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_type.dart';

import 'expense_factory.dart';

abstract class ExpenseParcelFactory {
  static ExpenseParcel generate({String? name, ExpenseType? type}) {
    //generate a string that contains the name if passed,
    //in begin, middle or final of the string

    var finalName = name == null
        ? null
        : faker.randomGenerator.boolean()
            ? '$name ${faker.lorem.word()}'
            : faker.randomGenerator.boolean()
                ? '${faker.lorem.word()} $name ${faker.lorem.word()}'
                : '${faker.lorem.word()} $name';

    var paidValue = faker.randomGenerator.decimal() * 500;
    var totalValue = faker.randomGenerator.decimal(min: paidValue + 0.1);

    return ExpenseParcel(
      expense: ExpenseFactory.generate(name: finalName, type: type),
      dueDate: faker.date.dateTime(minYear: 2020, maxYear: 2022),
      id: faker.randomGenerator.integer(20),
      paidValue: paidValue,
      remainingValue: totalValue - paidValue,
      paymentDate: faker.date.dateTime(minYear: 2022),
      totalValue: totalValue,
    );
  }

  static ExpenseParcel generatePaidParcel() {
    var expense = ExpenseFactory.generate();
    return ExpenseParcel(
      expense: expense,
      dueDate: faker.date.dateTime(minYear: 2020, maxYear: 2022),
      id: faker.randomGenerator.integer(20),
      paidValue: expense.value,
      remainingValue: expense.value - expense.value,
      paymentDate: faker.date.dateTime(minYear: 2022),
      totalValue: expense.value,
    );
  }
}
