import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice_item.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';
import 'date_factory.dart';
import 'expense_factory.dart';

abstract class InvoiceItemFactory {
  static InvoiceItem generate({
    int? expenseId,
    double? value,
    Date? paymentDate,
  }) {
    return InvoiceItem(
      value: value ?? (faker.randomGenerator.decimal() * 500).roundToDecimal(),
      paymentDate: paymentDate ?? DateFactory.generate(),
      expense: ExpenseFactory.generate(id: expenseId, paidValue: value),
    );
  }
}
