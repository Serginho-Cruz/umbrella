import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_type.dart';

import 'date_factory.dart';
import 'frequency_factory.dart';
import 'income_type_factory.dart';

abstract class IncomeFactory {
  static Income generate({
    String? name,
    IncomeType? type,
    double? value,
    int? id,
    Date? paymentDate,
    Frequency? frequency,
    Date? dueDate,
    String? personName,
  }) {
    return Income(
      id: id ?? faker.randomGenerator.integer(20),
      name: name ?? faker.lorem.word(),
      value: value ?? faker.randomGenerator.decimal() * 500,
      paymentDate: paymentDate ?? DateFactory.generate(),
      frequency: frequency ?? FrequencyFactory.generate(),
      type: type ?? IncomeTypeFactory.generate(),
      personName: personName ??
          (faker.randomGenerator.boolean() ? null : faker.person.firstName()),
      dueDate: dueDate ?? DateFactory.generate(),
    );
  }
}
