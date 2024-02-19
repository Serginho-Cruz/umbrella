import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/expense_type_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/income_type_table.dart';

List<Map<String, dynamic>> get expenseTypesMap {
  return [
    {
      ExpenseTypeTable.name: 'Conta',
      ExpenseTypeTable.icon: 'icons/conta.png',
    },
    {
      ExpenseTypeTable.name: 'Juros',
      ExpenseTypeTable.icon: 'icons/juros.png',
    },
    {
      ExpenseTypeTable.name: 'Dívida Familiar',
      ExpenseTypeTable.icon: 'icons/familia.png',
    },
    {
      ExpenseTypeTable.name: 'Pagamento',
      ExpenseTypeTable.icon: 'icons/pagamento.png',
    },
    {
      ExpenseTypeTable.name: 'Roupas',
      ExpenseTypeTable.icon: 'icons/roupas.png',
    },
    {
      ExpenseTypeTable.name: 'Cosméticos',
      ExpenseTypeTable.icon: 'icons/cosmeticos.png',
    },
    {
      ExpenseTypeTable.name: 'Transporte',
      ExpenseTypeTable.icon: 'icons/transporte.png',
    },
    {
      ExpenseTypeTable.name: 'Alimentação',
      ExpenseTypeTable.icon: 'icons/alimentacao.png',
    },
    {
      ExpenseTypeTable.name: 'Estudo',
      ExpenseTypeTable.icon: 'icons/estudo.png',
    },
    {
      ExpenseTypeTable.name: 'Lazer',
      ExpenseTypeTable.icon: 'icons/lazer.png',
    },
    {
      ExpenseTypeTable.name: 'Moradia',
      ExpenseTypeTable.icon: 'icons/moradia.png',
    },
    {
      ExpenseTypeTable.name: 'Saúde',
      ExpenseTypeTable.icon: 'icons/saude.png',
    },
    {
      ExpenseTypeTable.name: 'Reparos',
      ExpenseTypeTable.icon: 'icons/reparos.png',
    },
    {
      ExpenseTypeTable.name: 'Outros',
      ExpenseTypeTable.icon: 'icons/outros.png',
    },
  ];
}

List<Map<String, dynamic>> get incomeTypesMap {
  return [
    {
      IncomeTypeTable.name: 'Salário',
      IncomeTypeTable.icon: 'icons/salario.png',
    },
    {
      IncomeTypeTable.name: 'Presente',
      IncomeTypeTable.icon: 'icons/presente.png',
    },
    {
      IncomeTypeTable.name: 'Bônus',
      IncomeTypeTable.icon: 'icons/bonus.png',
    },
    {
      IncomeTypeTable.name: 'Família',
      IncomeTypeTable.icon: 'icons/familia.png',
    },
    {
      IncomeTypeTable.name: 'Benefício',
      IncomeTypeTable.icon: 'icons/beneficio.png',
    },
    {
      IncomeTypeTable.name: 'Pagamento',
      IncomeTypeTable.icon: 'icons/pagamento.png',
    },
    {
      IncomeTypeTable.name: 'Investimento',
      IncomeTypeTable.icon: 'icons/investimento.png',
    },
    {
      IncomeTypeTable.name: 'Rendimento',
      IncomeTypeTable.icon: 'icons/rendimento.png',
    },
    {
      IncomeTypeTable.name: 'Outros',
      IncomeTypeTable.icon: 'icons/outros.png',
    },
  ];
}
