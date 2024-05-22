import 'package:flutter_modular/flutter_modular.dart';
import 'package:umbrella_echonomics/app/modules/auth/auth_module.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/account_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/credit_card_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/expense_type_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/income_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/income_type_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/installment_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/invoice_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/payment_method_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/transaction_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/gets/get_expense_types.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/manage_account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/manage_credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/manage_income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/manage_installment.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/gets/get_expense_types.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/manage_account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/manage_credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/manage_installment.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/datasources/account_datasource.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/datasources/balance_datasource.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/datasources/credit_card_datasource.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/datasources/expense_datasource.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/datasources/income_datasource.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/datasources/transaction_datasource.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/account_datasource.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/balance_datasource.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/expense_type_datasource.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/transaction_datasource.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/repositories/account_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/repositories/balance_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/repositories/credit_card_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/repositories/expense_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/repositories/expense_type_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/repositories/installment_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/repositories/invoice_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/account_controller.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/credit_card_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/expense_type_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/screens/create_expense_screen.dart';

import 'src/data/repositories/balance_repository.dart';
import 'src/data/repositories/expense_repository.dart';
import 'src/data/usecases/manage_expense.dart';
import 'src/data/usecases/manage_invoice.dart';
import 'src/domain/usecases/manage_expense.dart';
import 'src/domain/usecases/manage_income.dart';
import 'src/domain/usecases/manage_invoice.dart';
import 'src/external/datasources/expense_type_datasource.dart';
import 'src/external/datasources/income_type_datasource.dart';
import 'src/infra/datasources/credit_card_datasource.dart';
import 'src/infra/datasources/expense_datasource.dart';
import 'src/infra/datasources/income_datasource.dart';
import 'src/infra/datasources/income_type_datasource.dart';
import 'src/infra/repositories/income_repository.dart';
import 'src/infra/repositories/income_type_repository.dart';
import 'src/infra/repositories/payment_method_repository.dart';
import 'src/infra/repositories/transaction_repository.dart';
import 'src/presenter/controllers/expense_store.dart';
import 'src/presenter/controllers/income_store.dart';
import 'src/presenter/screens/home_screen.dart';

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
    i.addLazySingleton<AccountRepository>(() => AccountRepositoryImpl(i.get()));

    i.addLazySingleton<BalanceRepository>(() => BalanceRepositoryImpl(
        balanceDatasource: i.get(), accountRepository: i.get()));

    i.addLazySingleton<CreditCardRepository>(
      () => CreditCardRepositoryImpl(i.get()),
    );

    i.addLazySingleton<InvoiceRepository>(() => InvoiceRepositoryImpl());

    i.addLazySingleton<ExpenseRepository>(() => ExpenseRepositoryImpl(i.get()));

    i.addLazySingleton<ExpenseTypeRepository>(
      () => ExpenseTypeRepositoryImpl(i.get()),
    );

    i.addLazySingleton<IncomeRepository>(() => IncomeRepositoryImpl(i.get()));

    i.addLazySingleton<IncomeTypeRepository>(
        () => IncomeTypeRepositoryImpl(i.get()));

    i.addLazySingleton<InstallmentRepository>(
        () => InstallmentRepositoryImpl());

    i.addLazySingleton<TransactionRepository>(
        () => TransactionRepositoryImpl(i.get()));

    i.addLazySingleton<PaymentMethodRepository>(
        () => PaymentMethodRepositoryImpl());
  }

  void _addUsecases(Injector i) {
    i.addLazySingleton<ManageAccount>(() => ManageAccountImpl(i.get()));

    i.addLazySingleton<ManageCreditCard>(
      () => ManageCreditCardImpl(
        cardRepository: i.get(),
        invoiceRepository: i.get(),
      ),
    );

    i.addLazySingleton<GetExpenseTypes>(() => RemoteGetExpenseTypes(i.get()));

    i.addLazySingleton<ManageExpense>(() => ManageExpenseImpl(
          expenseRepository: i.get(),
          balanceRepository: i.get(),
          installmentRepository: i.get(),
          invoiceRepository: i.get(),
          manageInstallment: i.get(),
          manageInvoice: i.get(),
          paymentMethodRepository: i.get(),
          transactionRepository: i.get(),
        ));

    i.addLazySingleton<ManageIncome>(
        () => ManageIncomeImpl(incomeRepository: i.get()));

    i.addLazySingleton<ManageInstallment>(() => ManageInstallmentImpl());

    i.addLazySingleton<ManageInvoice>(() => ManageInvoiceImpl());
  }

  void _addControllers(Injector i) {
    i.addLazySingleton<AccountStore>(
        () => AccountStore(authController: i.get(), manageAccount: i.get()));

    i.addLazySingleton<CreditCardStore>(
      () => CreditCardStore(manageCreditCard: i.get(), authController: i.get()),
    );

    i.addLazySingleton<ExpenseTypeStore>(() => ExpenseTypeStore(i.get()));

    i.addLazySingleton<ExpenseStore>(() => ExpenseStore(i.get()));

    i.addLazySingleton<IncomeStore>(() => IncomeStore(i.get()));
  }
}
