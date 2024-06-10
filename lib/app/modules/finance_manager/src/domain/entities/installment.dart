import 'package:equatable/equatable.dart';

import 'credit_card.dart';
import 'expense.dart';
import 'installment_parcel.dart';
import 'invoice.dart';
import 'paiyable.dart';

class Installment extends Equatable {
  final int id;
  final double value;
  final CreditCard card;
  final int parcelsNumber;
  final int actualParcel;
  final Paiyable paiyable;
  final List<InstallmentParcel> parcels;

  const Installment({
    required this.id,
    required this.card,
    required this.value,
    required this.parcelsNumber,
    required this.actualParcel,
    required this.paiyable,
    required this.parcels,
  }) : assert(paiyable is Expense || paiyable is Invoice);

  Installment copyWith({
    int? id,
    CreditCard? card,
    int? parcelsNumber,
    int? actualParcel,
    Paiyable? paiyable,
    double? value,
    List<InstallmentParcel>? parcels,
  }) {
    return Installment(
      id: id ?? this.id,
      card: card ?? this.card,
      parcelsNumber: parcelsNumber ?? this.parcelsNumber,
      actualParcel: actualParcel ?? this.actualParcel,
      paiyable: paiyable ?? this.paiyable,
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
        paiyable,
        parcels,
      ];
}
