import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';

abstract class FrequencyFactory {
  static Frequency generate({int? number}) {
    return FrequencyMethods.fromInt(number ?? faker.randomGenerator.integer(5));
  }
}
