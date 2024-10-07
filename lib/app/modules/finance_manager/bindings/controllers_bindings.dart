import 'package:flutter_modular/flutter_modular.dart';

import '../src/presenter/controllers/account_store.dart';
import '../src/presenter/controllers/balance_store.dart';
import '../src/presenter/controllers/credit_card_store.dart';
import '../src/presenter/controllers/expense_category_store.dart';
import '../src/presenter/controllers/expense_store.dart';
import '../src/presenter/controllers/graphs_store.dart';
import '../src/presenter/controllers/income_store.dart';
import '../src/presenter/controllers/income_category_store.dart';

abstract class ControllersBindings {
  static void bind(Injector i) {
    i.addLazySingleton<AccountStore>(
        () => AccountStore(authStore: i(), manageAccount: i()));

    i.addLazySingleton(() => BalanceStore(i()));

    i.addLazySingleton<CreditCardStore>(
      () => CreditCardStore(
        manageCreditCard: i(),
        authStore: i(),
        filterCards: i(),
      ),
    );

    i.addLazySingleton<ExpenseCategoryStore>(() => ExpenseCategoryStore(i()));

    i.addLazySingleton<ExpenseStore>(() => ExpenseStore(
          filterExpenses: i(),
          manageExpense: i(),
          sortExpenses: i(),
        ));

    i.addLazySingleton<IncomeStore>(() => IncomeStore(
          filterIncomes: i(),
          sortIncomes: i(),
          manageIncome: i(),
          receiveIncome: i(),
        ));

    i.addLazySingleton<IncomeCategoryStore>(() => IncomeCategoryStore(i()));

    i.addLazySingleton<GraphsStore>(() => GraphsStore(i()));
  }
}
