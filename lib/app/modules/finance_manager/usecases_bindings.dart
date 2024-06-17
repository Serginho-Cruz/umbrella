import 'package:flutter_modular/flutter_modular.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/filters/filter_expenses.dart';

import 'src/data/usecases/filters/filter_incomes.dart';
import 'src/data/usecases/gets/get_expense_categories.dart';
import 'src/data/usecases/manage_account.dart';
import 'src/data/usecases/manage_credit_card.dart';
import 'src/data/usecases/manage_income.dart';
import 'src/data/usecases/manage_installment.dart';
import 'src/data/usecases/orders/order_incomes.dart';
import 'src/domain/usecases/filters/filter_expenses.dart';
import 'src/domain/usecases/filters/filter_incomes.dart';
import 'src/domain/usecases/gets/get_expense_categories.dart';
import 'src/data/usecases/gets/get_income_categories.dart';
import 'src/domain/usecases/manage_account.dart';
import 'src/domain/usecases/manage_credit_card.dart';
import 'src/domain/usecases/manage_installment.dart';
import 'src/domain/usecases/gets/get_income_categories.dart';
import 'src/data/usecases/manage_expense.dart';
import 'src/data/usecases/manage_invoice.dart';
import 'src/domain/usecases/manage_expense.dart';
import 'src/domain/usecases/manage_income.dart';
import 'src/domain/usecases/manage_invoice.dart';
import 'src/domain/usecases/orders/order_incomes.dart';

abstract class UsecasesBindings {
  static void bind(Injector i) {
    i.addLazySingleton<ManageAccount>(() => ManageAccountImpl(i()));

    i.addLazySingleton<ManageCreditCard>(
      () => ManageCreditCardImpl(
        cardRepository: i(),
        invoiceRepository: i(),
      ),
    );

    i.addLazySingleton<GetExpenseCategories>(
        () => RemoteGetExpenseCategories(i()));
    i.addLazySingleton<GetIncomeCategories>(
        () => RemoteGetIncomeCategories(i()));

    i.addLazySingleton<ManageExpense>(() => ManageExpenseImpl(
          expenseRepository: i(),
          balanceRepository: i(),
          installmentRepository: i(),
          invoiceRepository: i(),
          manageInstallment: i(),
          manageInvoice: i(),
          paymentMethodRepository: i(),
          transactionRepository: i(),
        ));

    i.addLazySingleton<ManageIncome>(
        () => ManageIncomeImpl(incomeRepository: i(), balanceRepository: i()));

    i.addLazySingleton<ManageInstallment>(() => ManageInstallmentImpl());

    i.addLazySingleton<ManageInvoice>(() => ManageInvoiceImpl());

    i.addLazySingleton<FilterExpenses>(FilterExpensesImpl.new);
    i.addLazySingleton<FilterIncomes>(FilterIncomesImpl.new);

    i.addLazySingleton<OrderIncomes>(OrderIncomesImpl.new);
  }
}
