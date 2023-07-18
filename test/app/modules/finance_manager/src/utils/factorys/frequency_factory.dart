import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';

abstract class FrequencyFactory {
  static Frequency generate() =>
      frequencyFromInt(faker.randomGenerator.integer(6));
}
