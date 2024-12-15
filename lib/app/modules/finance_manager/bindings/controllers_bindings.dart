import 'package:flutter_modular/flutter_modular.dart' show Injector, BindConfig;

import '../src/presenter/stores/implementations.dart';
import '../src/presenter/stores/month_store.dart';
import '../src/presenter/stores/payment_record_store.dart';
import '../src/presenter/stores/person_store.dart';

abstract class ControllersBindings {
  static void bind(Injector i) {
    i.addSingleton<MonthStore>(MonthStore.new);

    i.addLazySingleton<AccountStore>(
      () => AccountStore(
        authStore: i(),
        validateAccount: i(),
        manageAccount: i(),
      ),
      config: BindConfig(onDispose: (store) {
        store.dispose();
      }),
    );

    i.addLazySingleton<CreditCardStore>(
      () => CreditCardStore(
        manageCreditCard: i(),
        authStore: i(),
        filterCreditCard: i(),
        validate: i(),
      ),
      config: BindConfig(onDispose: (store) {
        store.dispose();
      }),
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
      config: BindConfig(onDispose: (store) {
        store.dispose();
      }),
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
      config: BindConfig(onDispose: (store) {
        store.dispose();
      }),
    );

    i.addLazySingleton<IncomeCategoryStore>(() => IncomeCategoryStore(i()));

    i.addLazySingleton<BalanceStore>(
      () => BalanceStore(
        monthStore: i(),
        usecase: i(),
        accountStore: i(),
        expenseStore: i(),
        incomeStore: i(),
      ),
      config: BindConfig(onDispose: (store) {
        store.dispose();
      }),
    );

    i.addLazySingleton<GraphsStore>(
      () => GraphsStore(usecase: i(), monthStore: i(), accountStore: i()),
    );

    i.addLazySingleton<PersonStore>(
      () => PersonStore(
        get: i(),
        obtainDebts: i(),
        expenseStore: i(),
        incomeStore: i(),
      ),
    );

    i.addLazySingleton<PaymentRecordStore>(
      () => PaymentRecordStore(
        accountStore: i(),
        filterUsecase: i(),
        getUsecase: i(),
        monthStore: i(),
        sort: i(),
      ),
    );
  }
}
