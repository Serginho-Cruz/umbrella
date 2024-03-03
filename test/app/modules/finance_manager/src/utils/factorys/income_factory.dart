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
    int? id,
    String? name,
    IncomeType? type,
    double? totalValue,
    double? paidValue,
    double? remainingValue,
    Date? paymentDate,
    Frequency? frequency,
    Date? dueDate,
    String? personName,
  }) {
    var total = totalValue ?? faker.randomGenerator.decimal(scale: 1000);
    var paid = paidValue ?? faker.randomGenerator.decimal(scale: total);

    return Income(
      id: id ?? faker.randomGenerator.integer(20),
      name: name ?? faker.lorem.word(),
      totalValue: total,
      paidValue: paid,
      remainingValue: total - paid,
      paymentDate: paymentDate ?? DateFactory.generate(),
      frequency: frequency ?? FrequencyFactory.generate(),
      type: type ?? IncomeTypeFactory.generate(),
      personName: personName ??
          (faker.randomGenerator.boolean() ? null : faker.person.firstName()),
      dueDate: dueDate ?? DateFactory.generate(),
    );
  }

  static Income generateReceived() {
    var value = faker.randomGenerator.decimal(min: 25.0, scale: 1000);
    return Income(
      id: faker.randomGenerator.integer(20),
      name: faker.randomGenerator.string(25),
      totalValue: value,
      paidValue: value,
      remainingValue: 0,
      dueDate: DateFactory.generate(),
      paymentDate: DateFactory.generate(),
      type: IncomeTypeFactory.generate(),
      frequency: FrequencyFactory.generate(),
    );
  }
}
