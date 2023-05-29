import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/mappers/transaction_mapper.dart';

import '../../utils/entities.dart';
import '../../utils/maps.dart';

void main() {
  test("To Map Method is Working", () {
    var result = TransactionMapper.toMap(transaction);

    expect(result, equals(transactionIncludeMap));
  });

  test("From Map Method is Working", () {
    var result = TransactionMapper.fromMap(transactionReadMap);

    expect(result, equals(transaction));
  });
}
