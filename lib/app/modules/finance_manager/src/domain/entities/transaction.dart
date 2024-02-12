import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import 'paiyable.dart';

class Transaction extends Equatable {
  final int id;
  final double value;
  final Date paymentDate;
  final Paiyable paiyable;
  final PaymentMethod paymentMethod;
  final bool isAdjust;
  final bool isReversal;

  const Transaction({
    required this.id,
    required this.value,
    required this.paymentDate,
    required this.paiyable,
    required this.paymentMethod,
    this.isAdjust = false,
    this.isReversal = false,
  });

  factory Transaction.withoutId({
    required double value,
    required Date paymentDate,
    required Paiyable paiyable,
    required PaymentMethod paymentMethod,
    bool isAdjust = false,
    bool isReversal = false,
  }) =>
      Transaction(
        id: 1,
        value: value,
        paymentDate: paymentDate,
        paiyable: paiyable,
        paymentMethod: paymentMethod,
        isAdjust: isAdjust,
        isReversal: isReversal,
      );

  Transaction copyWith({
    int? id,
    double? value,
    Date? paymentDate,
    Paiyable? paiyable,
    PaymentMethod? paymentMethod,
    bool? isAdjust,
    bool? isReversal,
  }) {
    return Transaction(
      id: id ?? this.id,
      value: value ?? this.value,
      paymentDate: paymentDate ?? this.paymentDate,
      paiyable: paiyable ?? this.paiyable,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isAdjust: isAdjust ?? this.isAdjust,
      isReversal: isReversal ?? this.isReversal,
    );
  }

  @override
  List<Object?> get props => [
        id,
        value,
        paymentDate,
        paiyable,
        paymentMethod,
        isAdjust,
        isReversal,
      ];
}
