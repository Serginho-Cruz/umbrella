import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/mappers/expense_mapper.dart';

import '../../utils/entities.dart';
import '../../utils/maps.dart';

void main() {
  test("To Map Method is Working", () {
    var result = ExpenseMapper.toMap(expense);

    expect(result, equals(expenseIncludeMap));
  });
  test("From Map Method is Working", () {
    var result = ExpenseMapper.fromMap(expenseReadMap);

    expect(result, equals(expense));
  });
}
