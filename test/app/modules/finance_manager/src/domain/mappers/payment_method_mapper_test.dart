import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/mappers/payment_method_mapper.dart';

import '../../utils/entities.dart';
import '../../utils/maps.dart';

void main() {
  test("To Map Method is Working", () {
    var result = PaymentMethodMapper.toMap(paymentMethod);

    expect(result, equals(paymentMethodMap));
  });
  test("From Map Method is Working", () {
    var result = PaymentMethodMapper.fromMap(paymentMethodMap);

    expect(result, equals(paymentMethod));
  });
}
