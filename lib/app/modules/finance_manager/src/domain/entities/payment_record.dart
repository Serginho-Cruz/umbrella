import 'package:equatable/equatable.dart';

import 'account.dart';
import 'date.dart';
import 'paiyable.dart';
import 'payment_method.dart';

class PaymentRecord<T extends Paiyable> extends Equatable {
  final String id;
  final Account usedAccount;
  final T paiyable;
  final PaymentMethod paymentMethod;
  final double value;
  final Date date;

  const PaymentRecord({
    required this.id,
    required this.usedAccount,
    required this.paiyable,
    required this.paymentMethod,
    required this.value,
    required this.date,
  });

  const PaymentRecord.credit({
    required this.id,
    required this.usedAccount,
    required this.paiyable,
    required this.value,
    required this.date,
  }) : paymentMethod = const PaymentMethod.credit();

  @override
  List<Object?> get props => [
        id,
        usedAccount,
        paiyable,
        paymentMethod,
        value,
        date,
      ];

  PaymentRecord<T> copyWith({
    String? id,
    Account? usedAccount,
    T? paiyable,
    PaymentMethod? paymentMethod,
    double? value,
    Date? date,
  }) {
    return PaymentRecord<T>(
      id: id ?? this.id,
      usedAccount: usedAccount ?? this.usedAccount,
      paiyable: paiyable ?? this.paiyable,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      value: value ?? this.value,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'ID: ${paiyable.id}';
  }
}
