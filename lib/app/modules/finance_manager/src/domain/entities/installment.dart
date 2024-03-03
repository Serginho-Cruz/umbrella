import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';

import 'credit_card.dart';
import 'installment_parcel.dart';

class Installment extends Equatable {
  final int id;
  final double value;
  final CreditCard card;
  final int parcelsNumber;
  final int actualParcel;
  final Expense expense;
  final List<InstallmentParcel> parcels;

  const Installment({
    required this.id,
    required this.card,
    required this.value,
    required this.parcelsNumber,
    required this.actualParcel,
    required this.expense,
    required this.parcels,
  });

  Installment copyWith({
    int? id,
    CreditCard? card,
    int? parcelsNumber,
    int? actualParcel,
    Expense? expense,
    double? value,
    List<InstallmentParcel>? parcels,
  }) {
    return Installment(
      id: id ?? this.id,
      card: card ?? this.card,
      parcelsNumber: parcelsNumber ?? this.parcelsNumber,
      actualParcel: actualParcel ?? this.actualParcel,
      expense: expense ?? this.expense,
      value: value ?? this.value,
      parcels: parcels ?? this.parcels,
    );
  }

  @override
  List<Object?> get props => [
        id,
        card,
        value,
        parcelsNumber,
        actualParcel,
        expense,
        parcels,
      ];
}
