import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import '../../utils/extensions.dart';
import 'paiyable.dart';

class Transaction extends Equatable {
  final int id;
  final double value;
  final DateTime paymentDate;
  final Paiyable paiyable;
  final PaymentMethod paymentMethod;

  const Transaction({
    required this.id,
    required this.value,
    required this.paymentDate,
    required this.paiyable,
    required this.paymentMethod,
  });

  factory Transaction.withoutId({
    required double value,
    required DateTime paymentDate,
    required Paiyable paiyable,
    required PaymentMethod paymentMethod,
  }) =>
      Transaction(
        id: 1,
        value: value,
        paymentDate: paymentDate,
        paiyable: paiyable,
        paymentMethod: paymentMethod,
      );

  @override
  List<Object?> get props => [
        id,
        value,
        paymentDate.date,
        paiyable,
        paymentMethod,
      ];
}
