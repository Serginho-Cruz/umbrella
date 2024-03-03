import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/installment.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/installment_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';

import 'credit_card_factory.dart';
import 'expense_factory.dart';

abstract class InstallmentFactory {
  static Installment generate({
    int? id,
    double? value,
    int? parcelsNumber,
    int? actualParcel,
    CreditCard? card,
    Expense? expense,
    Date? paymentDate,
    List<InstallmentParcel>? parcels,
  }) {
    if (parcels != null) {
      value = 0;
      parcelsNumber = parcels.length;
      actualParcel = faker.randomGenerator.integer(parcels.length);

      for (var element in parcels) {
        value = value! + element.value;
      }

      value = value!.roundToDecimal();
    }
    value = value ??
        faker.randomGenerator.decimal(min: 1000, scale: 3.5).roundToDecimal();

    parcelsNumber = parcelsNumber ?? faker.randomGenerator.integer(24, min: 3);

    actualParcel = actualParcel ?? faker.randomGenerator.integer(parcelsNumber);

    expense = expense ??
        ExpenseFactory.generate(
          totalValue: value + 500.0,
          paidValue: 0.0,
        );

    return Installment(
      id: id ?? faker.randomGenerator.integer(20),
      value: value,
      parcelsNumber: parcelsNumber,
      card: card ?? CreditCardFactory.generate(),
      actualParcel: actualParcel,
      expense: expense,
      parcels: parcels ??
          List.generate(
            parcelsNumber,
            (n) => generateParcel(
              parcelNumber: n,
              value: value! / n,
            ),
          ),
    );
  }

  static InstallmentParcel generateParcel({
    double? value,
    int? parcelNumber,
  }) {
    return InstallmentParcel(
      parcelNumber: parcelNumber ?? faker.randomGenerator.integer(12),
      value: value ?? faker.randomGenerator.decimal(),
      paymentDate: Date.today(),
    );
  }
}
