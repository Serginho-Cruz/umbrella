abstract final class FinanceRoutes {
  static const String _module = '/finance_manager';
  static const String _incomes = '/income';
  static const String _expenses = '/expense';
  static const String _cards = '/card';

  static const String home = '$_module/';
  static const String charts = '$_module/graphics';
  static const String persons = '$_module/persons';
  static const String records = '$_module/records';

  static const String incomes = '$_module$_incomes';
  static const String addIncome = '$_module$_incomes/add';
  static const String updateIncome = '$_module$_incomes/update';
  static const String payIncome = '$_module$_incomes/pay';

  static const String expenses = '$_module$_expenses';
  static const String addExpense = '$_module$_expenses/add';
  static const String updateExpense = '$_module$_expenses/update';
  static const String payExpense = '$_module$_expenses/pay';

  static const String cards = '$_module$_cards';
  static const String addCard = '$_module$_cards/add';
  static const String updateCard = '$_module$_cards/update';
}

abstract final class UnmodularFormatFinanceRoutes {
  static const String home = '/';
  static const String charts = '/graphics';

  static const String incomes = '/income';
  static const String addIncome = '$incomes/add';
  static const String updateIncome = '$incomes/update';
  static const String payIncome = '$incomes/pay';

  static const String expenses = '/expense';
  static const String addExpense = '$expenses/add';
  static const String updateExpense = '$expenses/update';
  static const String payExpense = '$expenses/pay';

  static const String cards = '/card';
  static const String addCard = '$cards/add';
  static const String updateCard = '$cards/update';

  static const String persons = '/persons';
  static const String records = '/records';
}
