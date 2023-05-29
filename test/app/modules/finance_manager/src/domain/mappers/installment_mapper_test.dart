import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/mappers/installment_mapper.dart';

import '../../utils/entities.dart';
import '../../utils/maps.dart';

void main() {
  test("To Map Method is Working", () {
    var result = InstallmentMapper.toMap(installment);

    expect(result, equals(installmentIncludeMap));
  });

  test("From Map Method is Working", () {
    var result = InstallmentMapper.fromMap(
      installmentReadMap,
      installment.parcels,
    );

    expect(result, equals(installment));
  });
}
