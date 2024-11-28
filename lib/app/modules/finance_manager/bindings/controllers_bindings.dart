import 'package:flutter_modular/flutter_modular.dart' show Injector;

import '../src/presenter/controllers/implementations.dart';
import '../src/presenter/controllers/month_store.dart';

abstract class ControllersBindings {
  static void bind(Injector i) {
    i.addSingleton<MonthStore>(MonthStore.new);

    i.addLazySingleton<AccountStore>(
      () => AccountStore(
        authStore: i(),
        manageAccount: i(),
      ),
    );

    i.addLazySingleton<CreditCardStore>(
      () => CreditCardStore(
        manageCreditCard: i(),
        authStore: i(),
        filterCreditCard: i(),
        validate: i(),
      ),
    );

    i.addLazySingleton<ExpenseCategoryStore>(() => ExpenseCategoryStore(i()));

    i.addLazySingleton<ExpenseStore>(
      () => ExpenseStore(
        monthStore: i(),
        validateExpense: i(),
        filterExpenses: i(),
        manageExpense: i(),
        sortExpenses: i(),
        payExpense: i(),
        accountStore: i(),
      ),
    );

    i.addLazySingleton<IncomeStore>(
      () => IncomeStore(
        filterIncomes: i(),
        sortIncomes: i(),
        manageIncome: i(),
        receiveIncome: i(),
        monthStore: i(),
        validateIncome: i(),
        accountStore: i(),
      ),
    );

    i.addLazySingleton<IncomeCategoryStore>(() => IncomeCategoryStore(i()));

    i.addLazySingleton<BalanceStore>(() {
      return BalanceStore(
        monthStore: i(),
        usecase: i(),
        accountStore: i(),
        expenseStore: i(),
        incomeStore: i(),
      );
    });

    i.addLazySingleton<GraphsStore>(
        () => GraphsStore(usecase: i(), monthStore: i(), accountStore: i()));
  }
}
