import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';

import 'credit_card_factory.dart';
import 'date_factory.dart';
import 'invoice_item_factory.dart';

abstract class InvoiceFactory {
  static Invoice generate({
    double? paidValue,
    double? totalValue,
    CreditCard? card,
    Date? closingDate,
    Date? dueDate,
  }) {
    return Invoice(
      id: faker.randomGenerator.integer(20),
      isClosed: faker.randomGenerator.boolean(),
      closingDate: closingDate ?? DateFactory.generate(),
      card: card ?? CreditCardFactory.generate(),
      itens: List.generate(8, (i) => InvoiceItemFactory.generate(expenseId: i)),
      paidValue:
          paidValue ?? (faker.randomGenerator.decimal() * 500).roundToDecimal(),
      remainingValue: (faker.randomGenerator.decimal() * 500).roundToDecimal(),
      dueDate: dueDate ?? DateFactory.generate(),
      totalValue: totalValue ??
          (faker.randomGenerator.decimal() * 1000).roundToDecimal(),
    );
  }
}
