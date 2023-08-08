import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';

import 'credit_card_factory.dart';
import 'invoice_item_factory.dart';

abstract class InvoiceFactory {
  static Invoice generate({
    double? paidValue,
    double? totalValue,
    DateTime? closingDate,
    DateTime? dueDate,
  }) {
    return Invoice(
      isClosed: faker.randomGenerator.boolean(),
      closingDate:
          closingDate ?? faker.date.dateTime(minYear: 2020, maxYear: 2023),
      card: CreditCardFactory.generate(),
      itens: List.generate(8, (i) => InvoiceItemFactory.generate(parcelId: i)),
      id: faker.randomGenerator.integer(20),
      paidValue:
          paidValue ?? (faker.randomGenerator.decimal() * 500).roundToDecimal(),
      remainingValue: (faker.randomGenerator.decimal() * 500).roundToDecimal(),
      dueDate: dueDate ?? faker.date.dateTime(minYear: 2020, maxYear: 2023),
      totalValue: totalValue ??
          (faker.randomGenerator.decimal() * 1000).roundToDecimal(),
    );
  }
}
