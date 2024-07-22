import 'package:flutter_modular/flutter_modular.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/filters/filter_expenses.dart';

import '../src/data/usecases/filters/filter_credit_cards.dart';
import '../src/data/usecases/filters/filter_incomes.dart';
import '../src/data/usecases/gets/get_balance.dart';
import '../src/data/usecases/gets/get_expense_categories.dart';
import '../src/data/usecases/manage_account.dart';
import '../src/data/usecases/manage_credit_card.dart';
import '../src/data/usecases/manage_income.dart';
import '../src/data/usecases/manage_installment.dart';
import '../src/data/usecases/sorts/sort_expenses.dart';
import '../src/data/usecases/sorts/sort_incomes.dart';
import '../src/domain/usecases/filters/filter_credit_card.dart';
import '../src/domain/usecases/filters/filter_expenses.dart';
import '../src/domain/usecases/filters/filter_incomes.dart';
import '../src/domain/usecases/gets/get_balance.dart';
import '../src/domain/usecases/gets/get_expense_categories.dart';
import '../src/data/usecases/gets/get_income_categories.dart';
import '../src/domain/usecases/manage_account.dart';
import '../src/domain/usecases/manage_credit_card.dart';
import '../src/domain/usecases/manage_installment.dart';
import '../src/domain/usecases/gets/get_income_categories.dart';
import '../src/data/usecases/manage_expense.dart';
import '../src/data/usecases/manage_invoice.dart';
import '../src/domain/usecases/manage_expense.dart';
import '../src/domain/usecases/manage_income.dart';
import '../src/domain/usecases/manage_invoice.dart';
import '../src/domain/usecases/sorts/sort_expenses.dart';
import '../src/domain/usecases/sorts/sort_incomes.dart';

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
  }
}
