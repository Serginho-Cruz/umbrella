import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/mappers/invoice_mapper.dart';

import '../../utils/entities.dart';
import '../../utils/maps.dart';

void main() {
  test("To Map Method is Working", () {
    var result = InvoiceMapper.toMap(invoice);

    expect(result, equals(invoiceIncludeMap));
  });

  test("From Map Method is Working", () {
    var result = InvoiceMapper.fromMap(
      map: invoiceReadMap,
      itens: invoiceItens,
    );

    expect(result, equals(invoice));
  });
}
