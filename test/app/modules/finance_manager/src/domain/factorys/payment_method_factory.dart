import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';

abstract class PaymentMethodFactory {
  static final Faker faker = Faker();

  static PaymentMethod generate() => PaymentMethod(
        id: faker.randomGenerator.integer(7),
        name: faker.lorem.word(),
        icon: faker.lorem.word(),
        isCredit: faker.randomGenerator.boolean(),
      );
}
