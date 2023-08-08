import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice_item.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';
import 'expense_parcel_factory.dart';

abstract class InvoiceItemFactory {
  static InvoiceItem generate({int? parcelId}) {
    return InvoiceItem(
      value: (faker.randomGenerator.decimal() * 500).roundToDecimal(),
      paymentDate: faker.date.dateTime(minYear: 2021, maxYear: 2023),
      parcel: ExpenseParcelFactory.generate(id: parcelId),
    );
  }
}
