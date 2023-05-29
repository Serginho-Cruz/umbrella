import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/mappers/credit_card_mapper.dart';

import '../../utils/entities.dart';
import '../../utils/maps.dart';

void main() {
  test("To Map Method is Working", () {
    var result = CreditCardMapper.toMap(card);

    expect(result, equals(cardMap));
  });

  test("From Map Method is Working", () {
    var result = CreditCardMapper.fromMap(cardMap);

    expect(result, equals(card));
  });
}
