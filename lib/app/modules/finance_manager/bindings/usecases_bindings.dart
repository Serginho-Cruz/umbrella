import 'package:flutter_modular/flutter_modular.dart' show Injector;
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/obtain_persons_debts.dart';

import '../src/data/usecases/implementations.dart';
import '../src/data/usecases/obtain_persons_debts_impl.dart';
import '../src/data/usecases/validates/validate_account_impl.dart';
import '../src/domain/usecases/interfaces.dart';
import '../src/domain/usecases/validates/validate_account.dart';
import '../src/domain/usecases/validates/validate_credit_card.dart';
import '../src/domain/usecases/validates/validate_income.dart';
import '../src/domain/usecases/validates/validate_expense.dart';

import '../src/data/usecases/validates/validate_credit_card_impl.dart';
import '../src/data/usecases/validates/validate_income_impl.dart';
import '../src/data/usecases/validates/validate_expense_impl.dart';

abstract class UsecasesBindings {
  static void bind(Injector i) {
    i.addLazySingleton<ManageAccount>(() => ManageAccountImpl(i()));

    i.addLazySingleton<GetBalance>(() => GetBalanceImpl(
          accountRepository: i(),
          balanceRepository: i(),
          expenseRepository: i(),
          incomeRepository: i(),
          invoiceRepository: i(),
        ));

    i.addLazySingleton<GetExpenseCategories>(
        () => RemoteGetExpenseCategories(i()));

    i.addLazySingleton<GetIncomeCategories>(
        () => RemoteGetIncomeCategories(i()));

    i.addLazySingleton<GetPaymentRecords>(() => GetPaymentRecordsImpl(i()));

    i.addLazySingleton<ManageExpense>(
      () => ManageExpenseImpl(
        expenseRepository: i(),
        balanceRepository: i(),
      ),
    );

    i.addLazySingleton<ManageIncome>(
        () => ManageIncomeImpl(incomeRepository: i(), balanceRepository: i()));

    i.addLazySingleton<ManageInvoice>(
      () => ManageInvoiceImpl(
        balanceRepository: i(),
        repository: i(),
      ),
    );

    i.addLazySingleton<FilterExpenses>(FilterExpensesImpl.new);
    i.addLazySingleton<FilterIncomes>(FilterIncomesImpl.new);
    i.addLazySingleton<FilterCreditCard>(FilterCreditCardsImpl.new);
    i.addLazySingleton<FilterPaymentRecords>(FilterPaymentRecordsImpl.new);

    i.addLazySingleton<SortIncomes>(SortIncomesImpl.new);
    i.addLazySingleton<SortExpenses>(SortExpensesImpl.new);
    i.addLazySingleton<SortPaymentRecords>(SortPaymentRecordsImpl.new);

    i.addLazySingleton<ValidateCreditCard>(ValidateCreditCardImpl.new);
    i.addLazySingleton<ValidateIncome>(ValidateIncomeImpl.new);
    i.addLazySingleton<ValidateExpense>(ValidateExpenseImpl.new);
    i.addLazySingleton<ValidateAccount>(ValidateAccountImpl.new);

    i.addLazySingleton<ManageCreditCard>(
      () => ManageCreditCardImpl(
        cardRepository: i(),
        invoiceRepository: i(),
        manageInvoice: i(),
      ),
    );

    i.addLazySingleton<ReceiveIncome>(() => ReceiveIncomeImpl(
        incomeRepository: i(),
        paymentRecordRepository: i(),
        balanceRepository: i()));

    i.addLazySingleton<PayExpense>(() => PayExpenseImpl(
        expenseRepository: i(),
        paymentRecordRepository: i(),
        balanceRepository: i()));

    i.addLazySingleton<GetGraphsData>(
      () => GetGraphsDataImpl(
        expenseRepository: i(),
        incomeRepository: i(),
        recordRepository: i(),
        getBalance: i(),
        sortRecords: i(),
      ),
    );

    i.addLazySingleton<GetPersons>(
        () => GetPersonsImpl(expenseRepository: i(), incomeRepository: i()));

    i.addLazySingleton<ObtainPersonsDebts>(() => ObtainPersonsDebtsImpl(i()));
  }
}
