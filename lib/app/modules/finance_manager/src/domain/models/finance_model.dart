import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';

import '../entities/category.dart';
import '../entities/frequency.dart';
import 'paiyable_model.dart';

abstract  class FinanceModel<T extends Paiyable> extends PaiyableModel<T> {
  final String name;
  final Frequency frequency;
  final Category category;
  final String? personName;

  FinanceModel({
    required super.id,
    required this.name,
    required super.totalValue,
    required super.paidValue,
    required super.remainingValue,
    required super.status,
    required super.account,
    super.paymentDate,
    required super.overdueDate,
    required this.category,
    required this.frequency,
    this.personName,
  });
}
