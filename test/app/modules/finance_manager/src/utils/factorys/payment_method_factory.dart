import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';

abstract class PaymentMethodFactory {
  static PaymentMethod generate() {
    return PaymentMethod(
      id: faker.randomGenerator.integer(20),
      name: faker.lorem.word(),
      isCredit: faker.randomGenerator.boolean(),
      icon: faker.image.image(),
    );
  }
}
