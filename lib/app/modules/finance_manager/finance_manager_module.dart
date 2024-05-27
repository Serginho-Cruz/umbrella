import 'package:flutter_modular/flutter_modular.dart';
import 'package:umbrella_echonomics/app/modules/auth/auth_module.dart';

import 'datasources.dart';
import 'repositories.dart';
import 'usecases.dart';
import 'controllers.dart';
import 'routes.dart';

class FinanceManagerModule extends Module {
  @override
  List<Module> get imports => [AuthModule()];

  @override
  void binds(Injector i) {
    _addDatasources(i);
    _addRepositories(i);
    _addUsecases(i);
    _addControllers(i);
  }

  @override
  void routes(RouteManager r) {
    r.add(
      ChildRoute(
        '/',
        child: (context) => HomeScreen(
          incomeStore: Modular.get(),
          expenseStore: Modular.get(),
          creditCardStore: Modular.get(),
          accountStore: Modular.get(),
        ),
      ),
    );
    r.add(
      ChildRoute(
        '/expense/add',
        child: (context) => CreateExpenseScreen(
          accountStore: Modular.get(),
          cardStore: Modular.get(),
          expenseStore: Modular.get(),
          typeStore: Modular.get(),
        ),
      ),
    );
    r.add(
      ChildRoute(
        '/income/add',
        child: (context) => CreateIncomeScreen(
          accountStore: Modular.get(),
          incomeStore: Modular.get(),
          typeStore: Modular.get(),
        ),
      ),
    );
  }

  void _addDatasources(Injector i) {
    i.addLazySingleton<AccountDatasource>(TemporaryAccountDatasource.new);

    i.addLazySingleton<BalanceDatasource>(TemporaryBalanceDatasource.new);

    i.addLazySingleton<CreditCardDatasource>(TemporaryCreditCardDatasource.new);

    i.addLazySingleton<ExpenseTypeDatasource>(
      TemporaryExpenseTypeDatasource.new,
    );

    i.addLazySingleton<IncomeTypeDatasource>(TemporaryIncomeTypeDatasource.new);
    i.addLazySingleton<ExpenseDatasource>(TemporaryExpenseDatasource.new);

    i.addLazySingleton<IncomeDatasource>(TemporaryIncomeDatasource.new);

    i.addLazySingleton<TransactionDatasource>(
        TemporaryTransactionDatasource.new);
  }

  void _addRepositories(Injector i) {
    i.addLazySingleton<AccountRepository>(() => AccountRepositoryImpl(i()));

    i.addLazySingleton<BalanceRepository>(() =>
        BalanceRepositoryImpl(balanceDatasource: i(), accountRepository: i()));

    i.addLazySingleton<CreditCardRepository>(
      () => CreditCardRepositoryImpl(i()),
    );

    i.addLazySingleton<InvoiceRepository>(() => InvoiceRepositoryImpl());

    i.addLazySingleton<ExpenseRepository>(() => ExpenseRepositoryImpl(i()));

    i.addLazySingleton<ExpenseTypeRepository>(
      () => ExpenseTypeRepositoryImpl(i()),
    );

    i.addLazySingleton<IncomeRepository>(() => IncomeRepositoryImpl(i()));

    i.addLazySingleton<IncomeTypeRepository>(
        () => IncomeTypeRepositoryImpl(i()));

    i.addLazySingleton<InstallmentRepository>(
        () => InstallmentRepositoryImpl());

    i.addLazySingleton<TransactionRepository>(
        () => TransactionRepositoryImpl(i()));

    i.addLazySingleton<PaymentMethodRepository>(
        () => PaymentMethodRepositoryImpl());
  }

  void _addUsecases(Injector i) {
    i.addLazySingleton<ManageAccount>(() => ManageAccountImpl(i()));

    i.addLazySingleton<ManageCreditCard>(
      () => ManageCreditCardImpl(
        cardRepository: i(),
        invoiceRepository: i(),
      ),
    );

    i.addLazySingleton<GetExpenseTypes>(() => RemoteGetExpenseTypes(i()));
    i.addLazySingleton<GetIncomeTypes>(() => RemoteGetIncomeTypes(i()));

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
  }

  void _addControllers(Injector i) {
    i.addLazySingleton<AccountStore>(
        () => AccountStore(authController: i(), manageAccount: i()));

    i.addLazySingleton<CreditCardStore>(
      () => CreditCardStore(manageCreditCard: i(), authController: i()),
    );

    i.addLazySingleton<ExpenseTypeStore>(() => ExpenseTypeStore(i()));

    i.addLazySingleton<ExpenseStore>(() => ExpenseStore(i()));

    i.addLazySingleton<IncomeStore>(() => IncomeStore(i()));

    i.addLazySingleton<IncomeTypeStore>(() => IncomeTypeStore(i()));
  }
}
