import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/mappers/expense_parcel_mapper.dart';

import '../../utils/entities.dart';
import '../../utils/maps.dart';

void main() {
  test('To Map Method is Working', () {
    var result = ExpenseParcelMapper.toMap(expenseParcel);

    expect(result, equals(expenseParcelIncludeMap));
  });

  test("From Map Method is Working", () {
    var result = ExpenseParcelMapper.fromMap(expenseParcelReadMap);

    expect(result, equals(expenseParcel));
  });
}
