import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';

abstract class PaymentMethodFactory {
  static PaymentMethod getRandom() {
    var methods = PaymentMethod.normals;
    return methods[faker.randomGenerator.integer(methods.length)];
  }
}
