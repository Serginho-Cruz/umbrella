import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';

abstract class CreditCardFactory {
  static CreditCard generate() {
    return CreditCard(
      id: faker.randomGenerator.integer(20),
      name: faker.lorem.word(),
      annuity: faker.randomGenerator.decimal(scale: 100),
      color: faker.color.color(),
      cardInvoiceClosingDate: faker.date.dateTime(minYear: 2021, maxYear: 2023),
      cardInvoiceDueDate: faker.date.dateTime(minYear: 2021, maxYear: 2023),
    );
  }
}
