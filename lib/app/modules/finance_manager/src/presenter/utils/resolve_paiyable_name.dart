import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/expense_model.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/income_model.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/invoice_model.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/paiyable_model.dart';

String resolvePaiyableTypeName(PaiyableModel model) {
  return switch (model) {
    ExpenseModel() => 'Despesa:',
    IncomeModel() => 'Receita:',
    Invoice() => 'Fatura:',
    PaiyableModel() => '',
  };
}

String resolvePaiyableName(PaiyableModel model) {
  return switch (model) {
    ExpenseModel() => model.name,
    IncomeModel() => model.name,
    InvoiceModel() =>
      '${model.card.name} / ${model.closingDate.monthName} de ${model.closingDate.year}',
    _ => '',
  };
}
