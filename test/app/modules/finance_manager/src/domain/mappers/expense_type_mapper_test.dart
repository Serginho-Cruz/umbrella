import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/mappers/expense_type_mapper.dart';

import '../../utils/entities.dart';
import '../../utils/maps.dart';

void main() {
  test("To Map Method is Working", () {
    var result = ExpenseTypeMapper.toMap(expenseType);

    expect(result, equals(expenseTypeMap));
  });
  test("From Map Method is Working", () {
    var result = ExpenseTypeMapper.fromMap(expenseTypeMap);

    expect(result, equals(expenseType));
  });
}
