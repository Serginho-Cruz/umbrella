import 'package:flutter_modular/flutter_modular.dart' show Injector;

import '../src/data/usecases/implementations.dart';
import '../src/domain/usecases/interfaces.dart';

abstract class UsecasesBindings {
  static void bind(Injector i) {
    i.addLazySingleton<ManageAccount>(() => ManageAccountImpl(i()));

    i.addLazySingleton<GetBalance>(() => GetBalanceImpl(
          accountRepository: i(),
          balanceRepository: i(),
          expenseRepository: i(),
          incomeRepository: i(),
          installmentRepository: i(),
          invoiceRepository: i(),
        ));

    i.addLazySingleton<GetExpenseCategories>(
        () => RemoteGetExpenseCategories(i()));

    i.addLazySingleton<GetIncomeCategories>(
        () => RemoteGetIncomeCategories(i()));

    i.addLazySingleton<ManageExpense>(
      () => ManageExpenseImpl(
        expenseRepository: i(),
        balanceRepository: i(),
      ),
    );

    i.addLazySingleton<ManageIncome>(
        () => ManageIncomeImpl(incomeRepository: i(), balanceRepository: i()));

    i.addLazySingleton<ManageInstallment>(() => ManageInstallmentImpl());

    i.addLazySingleton<ManageInvoice>(
      () => ManageInvoiceImpl(
        balanceRepository: i(),
        repository: i(),
      ),
    );

    i.addLazySingleton<FilterExpenses>(FilterExpensesImpl.new);
    i.addLazySingleton<FilterIncomes>(FilterIncomesImpl.new);
    i.addLazySingleton<FilterCreditCard>(FilterCreditCardsImpl.new);

    i.addLazySingleton<SortIncomes>(SortIncomesImpl.new);
    i.addLazySingleton<SortExpenses>(SortExpensesImpl.new);

    i.addLazySingleton<ManageCreditCard>(
      () => ManageCreditCardImpl(
        cardRepository: i(),
        invoiceRepository: i(),
        manageInvoice: i(),
      ),
    );

    i.addLazySingleton<ReceiveIncome>(() => ReceiveIncomeImpl(
        incomeRepository: i(),
        paymentMethodRepository: i(),
        paymentRecordRepository: i(),
        balanceRepository: i()));

    i.addLazySingleton<PayExpense>(() => PayExpenseImpl(
        expenseRepository: i(),
        paymentMethodRepository: i(),
        paymentRecordRepository: i(),
        balanceRepository: i()));

    i.addLazySingleton<GetGraphsData>(
      () => GetGraphsDataImpl(
        expenseRepository: i(),
        incomeRepository: i(),
        recordRepository: i(),
      ),
    );
  }
}
