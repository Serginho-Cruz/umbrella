import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/installment.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/installment_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';

import 'credit_card_factory.dart';
import 'expense_parcel_factory.dart';

abstract class InstallmentFactory {
  static Installment generate({
    int? id,
    double? totalValue,
    int? parcelsNumber,
    int? actualParcel,
    CreditCard? card,
    ExpenseParcel? expense,
    Date? paymentDate,
    List<InstallmentParcel>? parcels,
  }) {
    if (parcels != null) {
      totalValue = 0;
      parcelsNumber = parcels.length;
      actualParcel = faker.randomGenerator.integer(parcels.length);

      for (var element in parcels) {
        totalValue = totalValue! + element.parcel.totalValue;
      }

      totalValue = totalValue!.roundToDecimal();
    }
    totalValue = totalValue ??
        faker.randomGenerator.decimal(min: 1000, scale: 3.5).roundToDecimal();

    parcelsNumber = parcelsNumber ?? faker.randomGenerator.integer(24, min: 3);

    actualParcel = actualParcel ?? faker.randomGenerator.integer(parcelsNumber);

    expense = expense ??
        ExpenseParcelFactory.generate(
          totalValue: totalValue + 500.0,
          paidValue: 0.0,
        );

    return Installment(
      id: id ?? faker.randomGenerator.integer(20),
      totalValue: totalValue,
      parcelsNumber: parcelsNumber,
      card: card ?? CreditCardFactory.generate(),
      actualParcel: actualParcel,
      expense: expense,
      parcels: parcels ??
          List.generate(
            parcelsNumber,
            (n) => generateParcel(
              parcelNumber: n,
              parcel: ExpenseParcelFactory.generate(
                totalValue: (totalValue! / parcelsNumber!).roundToDecimal(),
                dueDate: paymentDate ?? Date.today(),
              ),
            ),
          ),
    );
  }

  static InstallmentParcel generateParcel({
    ExpenseParcel? parcel,
    double? minValue,
    int? parcelNumber,
  }) {
    return InstallmentParcel(
      parcel: parcel ??
          ExpenseParcelFactory.generate(
            totalValue: minValue != null ? minValue + 200.0 : null,
            paidValue: 0.0,
          ),
      parcelNumber: parcelNumber ?? faker.randomGenerator.integer(12),
    );
  }
}
