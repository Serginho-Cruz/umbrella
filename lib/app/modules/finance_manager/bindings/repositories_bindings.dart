import 'package:flutter_modular/flutter_modular.dart';

import '../src/data/repositories/account_repository.dart';
import '../src/data/repositories/credit_card_repository.dart';
import '../src/data/repositories/expense_category_repository.dart';
import '../src/data/repositories/income_repository.dart';
import '../src/data/repositories/income_category_repository.dart';
import '../src/data/repositories/installment_repository.dart';
import '../src/data/repositories/invoice_repository.dart';
import '../src/data/repositories/payment_method_repository.dart';
import '../src/data/repositories/transaction_repository.dart';
import '../src/infra/repositories/account_repository.dart';
import '../src/infra/repositories/balance_repository.dart';
import '../src/infra/repositories/credit_card_repository.dart';
import '../src/infra/repositories/expense_repository.dart';
import '../src/infra/repositories/expense_category_repository.dart';
import '../src/infra/repositories/installment_repository.dart';
import '../src/infra/repositories/invoice_repository.dart';
import '../src/data/repositories/balance_repository.dart';
import '../src/data/repositories/expense_repository.dart';
import '../src/infra/repositories/income_repository.dart';
import '../src/infra/repositories/income_category_repository.dart';
import '../src/infra/repositories/payment_method_repository.dart';
import '../src/infra/repositories/transaction_repository.dart';

abstract class RepositoriesBindings {
  static void bind(Injector i) {
    i.addLazySingleton<AccountRepository>(() => AccountRepositoryImpl(i()));

    i.addLazySingleton<BalanceRepository>(() =>
        BalanceRepositoryImpl(balanceDatasource: i(), accountRepository: i()));

    i.addLazySingleton<CreditCardRepository>(
      () => CreditCardRepositoryImpl(i()),
    );

    i.addLazySingleton<InvoiceRepository>(() => InvoiceRepositoryImpl(i()));

    i.addLazySingleton<ExpenseRepository>(() => ExpenseRepositoryImpl(i()));

    i.addLazySingleton<ExpenseCategoryRepository>(
      () => ExpenseCategoryRepositoryImpl(i()),
    );

    i.addLazySingleton<IncomeRepository>(() => IncomeRepositoryImpl(i()));

    i.addLazySingleton<IncomeCategoryRepository>(
        () => IncomeCategoryRepositoryImpl(i()));

    i.addLazySingleton<InstallmentRepository>(
        () => InstallmentRepositoryImpl());

    i.addLazySingleton<TransactionRepository>(
        () => TransactionRepositoryImpl(i()));

    i.addLazySingleton<PaymentMethodRepository>(
        () => PaymentMethodRepositoryImpl());
  }
}
