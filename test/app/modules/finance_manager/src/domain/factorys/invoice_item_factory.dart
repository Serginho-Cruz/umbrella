import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice_item.dart';
import 'expense_parcel_factory.dart';

abstract class InvoiceItemFactory {
  static final Faker faker = Faker();

  static InvoiceItem generate() => InvoiceItem(
        value: faker.randomGenerator.decimal(),
        date: faker.date.dateTime(),
        parcel: ExpenseParcelFactory.generate(),
      );

  static List<InvoiceItem> generateItens() =>
      List.generate(8, (_) => generate());
}
