import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/mappers/income_parcel_mapper.dart';

import '../../utils/entities.dart';
import '../../utils/maps.dart';

void main() {
  test('To Map Method is Working', () {
    var result = IncomeParcelMapper.toMap(incomeParcel);

    expect(result, equals(incomeParcelIncludeMap));
  });

  test("From Map Method is Working", () {
    var result = IncomeParcelMapper.fromMap(incomeParcelReadMap);

    expect(result, equals(incomeParcel));
  });
}
