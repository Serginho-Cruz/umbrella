import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/transaction.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/filters/ifilter_transactions.dart';

import 'expense_parcel_factory.dart';
import 'income_parcel_factory.dart';
import 'invoice_factory.dart';
import 'payment_method_factory.dart';

abstract class TransactionsFactory {
  static Transaction generate({PaymentMethod? method, double? minValue}) {
    return Transaction(
      id: faker.randomGenerator.integer(20),
      value: minValue != null
          ? faker.randomGenerator.decimal(scale: 2, min: minValue)
          : faker.randomGenerator.decimal(scale: 300),
      paymentDate: faker.date.dateTime(minYear: 2023, maxYear: 2025),
      paiyable: faker.randomGenerator.boolean()
          ? ExpenseParcelFactory.generate()
          : faker.randomGenerator.boolean()
              ? IncomeParcelFactory.generate()
              : InvoiceFactory.generate(),
      paymentMethod: method ?? PaymentMethodFactory.generate(),
    );
  }

  static Transaction generateWithType(TransactionType type) {
    var typesMap = <TransactionType, Paiyable>{
      TransactionType.expense: ExpenseParcelFactory.generate(),
      TransactionType.income: IncomeParcelFactory.generate(),
      TransactionType.invoice: InvoiceFactory.generate(),
    };

    return Transaction(
      id: faker.randomGenerator.integer(20),
      value: faker.randomGenerator.decimal(scale: 300),
      paymentDate: faker.date.dateTime(minYear: 2023, maxYear: 2025),
      paiyable: typesMap[type]!,
      paymentMethod: PaymentMethodFactory.generate(),
    );
  }
}
