import 'package:equatable/equatable.dart';
import 'credit_card.dart';
import 'expense.dart';
import 'installment_parcel.dart';
import 'payment_method.dart';

class Installment with EquatableMixin {
  int id;
  CreditCard? card;
  int parcelsNumber;
  int actualParcel;
  Expense expense;
  double totalValue;
  PaymentMethod paymentMethod;
  List<InstallmentParcel> parcels;

  Installment({
    required this.id,
    this.card,
    required this.totalValue,
    required this.parcelsNumber,
    required this.actualParcel,
    required this.expense,
    required this.paymentMethod,
    required this.parcels,
  });

  @override
  List<Object?> get props => [
        id,
        card,
        totalValue,
        parcelsNumber,
        actualParcel,
        expense,
        paymentMethod,
        parcels,
      ];

  factory Installment.withoutId({
    CreditCard? card,
    required double totalValue,
    required int parcelsNumber,
    required int actualParcel,
    required Expense expense,
    required PaymentMethod paymentMethod,
    required List<InstallmentParcel> parcels,
  }) =>
      Installment(
        id: 0,
        totalValue: totalValue,
        parcelsNumber: parcelsNumber,
        actualParcel: actualParcel,
        expense: expense,
        paymentMethod: paymentMethod,
        parcels: parcels,
      );
}
