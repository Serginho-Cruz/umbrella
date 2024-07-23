import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';

import '../entities/account.dart';
import '../entities/date.dart';
import 'status.dart';

abstract class PaiyableModel<T extends Paiyable> {
  final int id;
  final double totalValue;
  final double paidValue;
  final double remainingValue;
  final Status status;
  final Date overdueDate;
  final Account account;
  final Date? paymentDate;

  PaiyableModel({
    required this.id,
    required this.totalValue,
    required this.paidValue,
    required this.remainingValue,
    required this.status,
    required this.account,
    this.paymentDate,
    required this.overdueDate,
  });

  T toEntity();
}
