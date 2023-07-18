import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';

import 'credit_card_factory.dart';
import 'invoice_item_factory.dart';

abstract class InvoiceFactory {
  static Invoice generate() {
    return Invoice(
      isClosed: faker.randomGenerator.boolean(),
      closingDate: faker.date.dateTime(minYear: 2020, maxYear: 2023),
      card: CreditCardFactory.generate(),
      itens: List.generate(8, (_) => InvoiceItemFactory.generate()),
      id: faker.randomGenerator.integer(20),
      paidValue: faker.randomGenerator.decimal() * 500,
      remainingValue: faker.randomGenerator.decimal() * 500,
      dueDate: faker.date.dateTime(minYear: 2020, maxYear: 2023),
      totalValue: faker.randomGenerator.decimal() * 1000,
    );
  }
}
