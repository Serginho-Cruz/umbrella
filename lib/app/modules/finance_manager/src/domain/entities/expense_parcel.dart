import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/datetime_extension.dart';

import 'expense.dart';
import 'parcel.dart';
import 'payment_method.dart';

class ExpenseParcel extends Parcel {
  Expense expense;
  DateTime expirationDate;
  PaymentMethod paymentMethod;

  ExpenseParcel({
    required this.expense,
    required this.expirationDate,
    required this.paymentMethod,
    required super.id,
    required super.paidValue,
    required super.remainingValue,
    required super.paymentDate,
    required super.parcelValue,
  });

  @override
  List<Object?> get props => [
        id,
        expense,
        paymentMethod,
        expirationDate,
        paidValue,
        remainingValue,
        paymentDate.date,
        parcelValue,
      ];
}
