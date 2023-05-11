import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_parcel.dart';

import 'income_factory.dart';

abstract class IncomeParcelFactory {
  static final Faker faker = Faker();

  static IncomeParcel generate() {
    double paidValue = faker.randomGenerator.decimal();
    double value = faker.randomGenerator.decimal(min: paidValue);

    return IncomeParcel(
      income: IncomeFactory.generate(),
      id: faker.randomGenerator.integer(100),
      paidValue: paidValue,
      remainingValue: value - paidValue,
      paymentDate: faker.date.dateTime(),
      parcelValue: value,
    );
  }
}
