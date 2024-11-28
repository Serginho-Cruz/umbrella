import 'package:flutter_modular/flutter_modular.dart' show Injector;

import '../src/data/repositories/interfaces.dart';
import '../src/infra/repositories/implementations.dart';

abstract class RepositoriesBindings {
  static void bind(Injector i) {
    i.addLazySingleton<AccountRepository>(() => AccountRepositoryImpl(i()));

    i.addLazySingleton<BalanceRepository>(
      () => BalanceRepositoryImpl(
        balanceDatasource: i(),
        accountRepository: i(),
      ),
    );

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

    i.addLazySingleton<PaymentRecordRepository>(
        () => PaymentRecordRepositoryImpl(i()));
  }
}
