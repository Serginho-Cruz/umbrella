import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'date_factory.dart';

abstract class CreditCardFactory {
  static CreditCard generate({
    int? id,
    String? name,
    double? annuity,
    String? color,
    Date? cardInvoiceClosingDate,
    Date? cardInvoiceDueDate,
  }) {
    return CreditCard(
      id: id ?? faker.randomGenerator.integer(20),
      name: name ?? faker.lorem.word(),
      annuity: annuity ?? faker.randomGenerator.decimal(scale: 100),
      color: color ?? faker.color.color(),
      cardInvoiceClosingDate: cardInvoiceClosingDate ?? DateFactory.generate(),
      cardInvoiceDueDate: cardInvoiceDueDate ?? DateFactory.generate(),
    );
  }
}
