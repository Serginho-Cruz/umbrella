import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_parcel.dart';
import 'expense_factory.dart';
import 'payment_method_factory.dart';

abstract class ExpenseParcelFactory {
  static final Faker faker = Faker();

  static ExpenseParcel generate({Expense? expense}) {
    double paidValue = faker.randomGenerator.decimal();
    double value = faker.randomGenerator.decimal(min: paidValue);

    return ExpenseParcel(
      id: faker.randomGenerator.integer(100),
      expense: expense ?? ExpenseFactory.generate(),
      expirationDate: expense?.expirationDate ?? faker.date.dateTime(),
      paymentMethod: PaymentMethodFactory.generate(),
      paidValue: paidValue,
      remainingValue: value - paidValue,
      paymentDate: faker.date.dateTime(),
      parcelValue: value,
    );
  }

  static List<ExpenseParcel> generateList({Expense? expense, int length = 4}) =>
      List.generate(length, (_) => generate(expense: expense));
}
