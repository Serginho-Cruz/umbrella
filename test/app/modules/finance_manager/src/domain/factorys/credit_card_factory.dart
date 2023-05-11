import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';

abstract class CreditCardFactory {
  static final Faker faker = Faker();

  static CreditCard generate() {
    DateTime closeDate = faker.date.dateTime(minYear: 2020, maxYear: 2030);
    return CreditCard(
      id: faker.randomGenerator.integer(5),
      name: faker.company.name(),
      annuity: faker.randomGenerator.decimal(),
      color: faker.color.color(),
      cardInvoiceClosingDate: closeDate,
      cardInvoiceExpirationDate: closeDate.add(const Duration(days: 10)),
    );
  }

  static List<CreditCard> generateCards() =>
      List.generate(4, (_) => generate());
}
