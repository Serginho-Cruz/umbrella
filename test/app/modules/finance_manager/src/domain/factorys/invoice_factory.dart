import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';
import 'credit_card_factory.dart';
import 'invoice_item_factory.dart';

abstract class InvoiceFactory {
  static final Faker faker = Faker();

  static Invoice generate() {
    CreditCard card = CreditCardFactory.generate();

    return Invoice(
      id: faker.randomGenerator.integer(20),
      value: faker.randomGenerator.decimal(),
      isClosed: faker.randomGenerator.boolean(),
      expirationDate: card.cardInvoiceExpirationDate,
      closingDate: card.cardInvoiceClosingDate,
      card: card,
      itens: InvoiceItemFactory.generateItens(),
    );
  }

  static List<Invoice> generateInvoices() =>
      List.generate(4, (_) => generate());
}
