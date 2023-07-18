import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_type.dart';

import 'income_factory.dart';

abstract class IncomeParcelFactory {
  static IncomeParcel generate({String? name, IncomeType? type}) {
    var finalName = name == null
        ? null
        : faker.randomGenerator.boolean()
            ? '$name ${faker.lorem.word()}'
            : faker.randomGenerator.boolean()
                ? '${faker.lorem.word()} $name ${faker.lorem.word()}'
                : '${faker.lorem.word()} $name';

    var paidValue = faker.randomGenerator.decimal() * 500;
    var totalValue = faker.randomGenerator.decimal(min: paidValue + 0.1);

    return IncomeParcel(
      income: IncomeFactory.generate(name: finalName, type: type),
      id: faker.randomGenerator.integer(20),
      paidValue: paidValue,
      remainingValue: totalValue - paidValue,
      dueDate: faker.date.dateTime(minYear: 2023, maxYear: 2025),
      paymentDate: faker.date.dateTime(minYear: 2023, maxYear: 2025),
      totalValue: totalValue,
    );
  }

  static IncomeParcel generateReceived() {
    var income = IncomeFactory.generate();
    return IncomeParcel(
      income: income,
      dueDate: faker.date.dateTime(minYear: 2020, maxYear: 2022),
      id: faker.randomGenerator.integer(20),
      paidValue: income.value,
      remainingValue: income.value - income.value,
      paymentDate: faker.date.dateTime(minYear: 2022),
      totalValue: income.value,
    );
  }
}
