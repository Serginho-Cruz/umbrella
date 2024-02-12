import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_type.dart';

import 'date_factory.dart';
import 'income_factory.dart';

abstract class IncomeParcelFactory {
  static IncomeParcel generate({
    String? name,
    IncomeType? type,
    double? paidValue,
    double? totalValue,
    Date? paymentDate,
    Date? dueDate,
  }) {
    var finalName = name == null
        ? null
        : faker.randomGenerator.boolean()
            ? '$name ${faker.lorem.word()}'
            : faker.randomGenerator.boolean()
                ? '${faker.lorem.word()} $name ${faker.lorem.word()}'
                : '${faker.lorem.word()} $name';

    paidValue = paidValue ?? faker.randomGenerator.decimal() * 500;
    totalValue =
        totalValue ?? faker.randomGenerator.decimal(min: paidValue + 0.1);

    return IncomeParcel(
      income: IncomeFactory.generate(name: finalName, type: type),
      id: faker.randomGenerator.integer(20),
      paidValue: paidValue,
      remainingValue: totalValue - paidValue,
      dueDate: dueDate ?? DateFactory.generate(),
      paymentDate: paymentDate ?? DateFactory.generate(),
      totalValue: totalValue,
    );
  }

  static IncomeParcel generateReceived() {
    var income = IncomeFactory.generate();
    return IncomeParcel(
      income: income,
      dueDate: DateFactory.generate(),
      id: faker.randomGenerator.integer(20),
      paidValue: income.value,
      remainingValue: 0.0,
      paymentDate: DateFactory.generate(),
      totalValue: income.value,
    );
  }
}
