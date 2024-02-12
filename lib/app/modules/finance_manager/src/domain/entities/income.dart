import 'package:equatable/equatable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'frequency.dart';
import 'income_type.dart';

class Income extends Equatable {
  final int id;
  final String name;
  final double value;
  final Date dueDate;
  final Date? paymentDate;
  final Frequency frequency;
  final String? personName;
  final IncomeType type;

  const Income({
    required this.id,
    required this.name,
    required this.value,
    required this.dueDate,
    this.paymentDate,
    required this.frequency,
    this.personName,
    required this.type,
  });

  factory Income.withoutId({
    required String name,
    required double value,
    required Date dueDate,
    Date? paymentDate,
    required Frequency frequency,
    String? personName,
    required IncomeType type,
  }) {
    return Income(
      id: 0,
      frequency: frequency,
      name: name,
      dueDate: dueDate,
      paymentDate: paymentDate,
      personName: personName,
      type: type,
      value: value,
    );
  }

  Income copyWith({
    int? id,
    String? name,
    double? value,
    Date? dueDate,
    Date? paymentDate,
    Frequency? frequency,
    String? personName,
    IncomeType? type,
  }) {
    return Income(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      dueDate: dueDate ?? this.dueDate,
      paymentDate: paymentDate ?? this.paymentDate,
      frequency: frequency ?? this.frequency,
      personName: personName ?? this.personName,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        value,
        dueDate,
        paymentDate,
        frequency,
        type,
        personName,
      ];
}
