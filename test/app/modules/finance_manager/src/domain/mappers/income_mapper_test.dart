import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/mappers/income_mapper.dart';

import '../../utils/entities.dart';
import '../../utils/maps.dart';

void main() {
  test("To Map Method is Working", () {
    var result = IncomeMapper.toMap(income);

    expect(result, equals(incomeIncludeMap));
  });
  test("From Map Method is Working", () {
    var result = IncomeMapper.fromMap(incomeReadMap);

    expect(result, equals(income));
  });
}
