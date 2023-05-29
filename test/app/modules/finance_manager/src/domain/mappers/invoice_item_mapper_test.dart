import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/mappers/invoice_item_mapper.dart';

import '../../utils/entities.dart';
import '../../utils/maps.dart';

void main() {
  test("To Map Method is Working", () {
    var result = InvoiceItemMapper.toMap(
      item: invoiceItens.first,
      invoiceId: invoice.id,
    );

    expect(result, equals(invoiceItemIncludeMap));
  });

  test("From Map Method is Working", () {
    var result = InvoiceItemMapper.fromMap(invoiceItemReadMap);

    expect(result, equals(invoiceItens.first));
  });
}
