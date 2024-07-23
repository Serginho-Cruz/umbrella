import 'package:equatable/equatable.dart';
import 'account.dart';
import 'date.dart';
import 'paiyable.dart';
import 'payment_method.dart';

class Payment<T extends Paiyable> extends Equatable {
  final Account usedAccount;
  final T paiyable;
  final PaymentMethod paymentMethod;
  final double value;
  final Date date;

  const Payment({
    required this.usedAccount,
    required this.paiyable,
    required this.paymentMethod,
    required this.value,
    required this.date,
  });

  const Payment.credit({
    required this.usedAccount,
    required this.paiyable,
    required this.value,
    required this.date,
  }) : paymentMethod = const PaymentMethod.credit();

  @override
  List<Object?> get props => [
        usedAccount,
        paiyable,
        paymentMethod,
        value,
        date,
      ];
}
