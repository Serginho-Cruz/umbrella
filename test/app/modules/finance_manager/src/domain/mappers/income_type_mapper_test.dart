import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/mappers/income_type_mapper.dart';

import '../../utils/entities.dart';
import '../../utils/maps.dart';

void main() {
  test("To Map Method is Working", () {
    var result = IncomeTypeMapper.toMap(incomeType);

    expect(result, equals(incomeTypeMap));
  });
  test("From Map Method is Working", () {
    var result = IncomeTypeMapper.fromMap(incomeTypeMap);

    expect(result, equals(incomeType));
  });
}
