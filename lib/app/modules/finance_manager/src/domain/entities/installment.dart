import 'package:equatable/equatable.dart';

import 'credit_card.dart';
import 'expense_parcel.dart';
import 'installment_parcel.dart';

class Installment extends Equatable {
  final int id;
  final CreditCard card;
  final int parcelsNumber;
  final int actualParcel;
  final ExpenseParcel expense;
  final double totalValue;
  final List<InstallmentParcel> parcels;

  const Installment({
    required this.id,
    required this.card,
    required this.totalValue,
    required this.parcelsNumber,
    required this.actualParcel,
    required this.expense,
    required this.parcels,
  });

  factory Installment.withoutId({
    required CreditCard card,
    required double totalValue,
    required int parcelsNumber,
    required int actualParcel,
    required ExpenseParcel expense,
    required List<InstallmentParcel> parcels,
  }) =>
      Installment(
        id: 0,
        card: card,
        totalValue: totalValue,
        parcelsNumber: parcelsNumber,
        actualParcel: actualParcel,
        expense: expense,
        parcels: parcels,
      );

  Installment copyWith({
    int? id,
    CreditCard? card,
    int? parcelsNumber,
    int? actualParcel,
    ExpenseParcel? expense,
    double? totalValue,
    List<InstallmentParcel>? parcels,
  }) {
    return Installment(
      id: id ?? this.id,
      card: card ?? this.card,
      parcelsNumber: parcelsNumber ?? this.parcelsNumber,
      actualParcel: actualParcel ?? this.actualParcel,
      expense: expense ?? this.expense,
      totalValue: totalValue ?? this.totalValue,
      parcels: parcels ?? this.parcels,
    );
  }

  @override
  List<Object?> get props => [
        id,
        card,
        totalValue,
        parcelsNumber,
        actualParcel,
        expense,
        parcels,
      ];
}
