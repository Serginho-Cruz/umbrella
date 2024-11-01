import 'package:flutter_modular/flutter_modular.dart' show Injector;

import '../src/presenter/controllers/implementations.dart';

abstract class ControllersBindings {
  static void bind(Injector i) {
    i.addLazySingleton<AccountStore>(
      () => AccountStore(
        authStore: i(),
        manageAccount: i(),
      ),
    );

    i.addLazySingleton(
      () => BalanceStore(i()),
    );

    i.addLazySingleton<CreditCardStore>(
      () => CreditCardStore(
        manageCreditCard: i(),
        authStore: i(),
        filterCards: i(),
      ),
    );

    i.addLazySingleton<ExpenseCategoryStore>(() => ExpenseCategoryStore(i()));

    i.addLazySingleton<ExpenseStore>(
      () => ExpenseStore(
        filterExpenses: i(),
        manageExpense: i(),
        sortExpenses: i(),
        payExpense: i(),
      ),
    );

    i.addLazySingleton<IncomeStore>(
      () => IncomeStore(
        filterIncomes: i(),
        sortIncomes: i(),
        manageIncome: i(),
        receiveIncome: i(),
      ),
    );

    i.addLazySingleton<IncomeCategoryStore>(() => IncomeCategoryStore(i()));

    i.addLazySingleton<GraphsStore>(() => GraphsStore(i()));
  }
}
