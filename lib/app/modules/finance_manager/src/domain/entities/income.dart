import 'package:equatable/equatable.dart';

import '../../utils/extensions.dart';
import 'frequency.dart';
import 'income_type.dart';

class Income extends Equatable {
  final int id;
  final String name;
  final double value;
  final DateTime paymentDate;
  final Frequency frequency;
  final String? personName;
  final IncomeType type;

  const Income({
    required this.id,
    required this.name,
    required this.value,
    required this.paymentDate,
    required this.frequency,
    this.personName,
    required this.type,
  });

  factory Income.withoutId({
    required String name,
    required double value,
    required DateTime paymentDate,
    required Frequency frequency,
    String? personName,
    required IncomeType type,
  }) {
    return Income(
      id: 0,
      frequency: frequency,
      name: name,
      paymentDate: paymentDate,
      personName: personName,
      type: type,
      value: value,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        value,
        paymentDate.date,
        frequency,
        type,
        personName,
      ];
}
