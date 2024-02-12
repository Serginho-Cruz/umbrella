import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_type.dart';

abstract class IncomeTypeFactory {
  static IncomeType generate({
    int? id,
    String? name,
    String? icon,
  }) {
    return IncomeType(
      id: id ?? faker.randomGenerator.integer(20),
      name: name ?? faker.lorem.word(),
      icon: icon ?? faker.image.image(),
    );
  }
}
