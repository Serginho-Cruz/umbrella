import 'package:flutter_modular/flutter_modular.dart';

import '../src/presenter/controllers/account_controller.dart';
import '../src/presenter/controllers/credit_card_store.dart';
import '../src/presenter/controllers/expense_category_store.dart';
import '../src/presenter/controllers/expense_store.dart';
import '../src/presenter/controllers/income_store.dart';
import '../src/presenter/controllers/income_category_store.dart';

abstract class ControllersBindings {
  static void bind(Injector i) {
    i.addLazySingleton<AccountStore>(
        () => AccountStore(authController: i(), manageAccount: i()));

    i.addLazySingleton<CreditCardStore>(
      () => CreditCardStore(
        manageCreditCard: i(),
        authController: i(),
        filterCards: i(),
      ),
    );

    i.addLazySingleton<ExpenseCategoryStore>(() => ExpenseCategoryStore(i()));

    i.addLazySingleton<ExpenseStore>(() => ExpenseStore(
          filterExpenses: i(),
          manageExpense: i(),
          orderExpenses: i(),
        ));

    i.addLazySingleton<IncomeStore>(() => IncomeStore(
          filterIncomes: i(),
          orderIncomes: i(),
          manageIncome: i(),
        ));

    i.addLazySingleton<IncomeCategoryStore>(() => IncomeCategoryStore(i()));
  }
}
