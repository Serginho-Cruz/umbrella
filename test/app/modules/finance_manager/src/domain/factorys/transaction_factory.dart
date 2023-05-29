import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/transaction.dart';
import 'expense_parcel_factory.dart';
import 'income_parcel_factory.dart';

abstract class TransactionFactory {
  static final Faker faker = Faker();

  static Transaction generate() {
    Parcel parcel = faker.randomGenerator.boolean()
        ? ExpenseParcelFactory.generate()
        : IncomeParcelFactory.generate();

    return Transaction(
      id: faker.randomGenerator.integer(10),
      value: faker.randomGenerator.decimal(),
      date: faker.date.dateTime(),
      parcel: parcel,
    );
  }
}
