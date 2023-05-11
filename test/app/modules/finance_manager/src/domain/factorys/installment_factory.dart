import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/installment.dart';

import 'expense_factory.dart';
import 'expense_parcel_factory.dart';
import 'payment_method_factory.dart';

abstract class InstalmentFactory {
  static final Faker faker = Faker();

  static Installment generate() {
    Expense expense = ExpenseFactory.generate();
    int parcelsNumber = faker.randomGenerator.integer(4, min: 2);
    return Installment(
      id: faker.randomGenerator.integer(5),
      parcelsNumber: parcelsNumber,
      actualParcel: faker.randomGenerator.integer(parcelsNumber, min: 2),
      expense: expense,
      paymentMethod: PaymentMethodFactory.generate(),
      parcels: ExpenseParcelFactory.generateList(
        expense: expense,
        length: parcelsNumber,
      ),
    );
  }
}
