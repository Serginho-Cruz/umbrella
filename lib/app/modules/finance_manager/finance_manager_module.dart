import 'package:flutter_modular/flutter_modular.dart';
import 'package:umbrella_echonomics/app/modules/auth/auth_module.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/icredit_card_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_type_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iinvoice_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/gets/get_expense_types.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/manage_credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/gets/iget_expense_types.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imanage_credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/datasources/credit_card_datasource.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/iexpense_type_datasource.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/repositories/credit_card_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/repositories/expense_type_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/repositories/invoice_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/credit_card_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/expense_type_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/screens/create_expense_screen.dart';

import 'src/external/datasources/expense_type_datasource.dart';
import 'src/infra/datasources/icredit_card_datasource.dart';
import 'src/presenter/screens/home_screen.dart';

class FinanceManagerModule extends Module {
  @override
  List<Module> get imports => [AuthModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<ICreditCardDatasource>(() => CreditCardDatasource());
    i.addLazySingleton<IExpenseTypeDatasource>(() => ExpenseTypeDatasource());
    i.addLazySingleton<ICreditCardRepository>(
      () => CreditCardRepository(creditCardDatasource: i.get()),
    );
    i.addLazySingleton<IExpenseTypeRepository>(
      () => ExpenseTypeRepository(i.get()),
    );
    i.addLazySingleton<IInvoiceRepository>(() => InvoiceRepository());
    i.addLazySingleton<IManageCreditCard>(
      () => ManageCreditCard(
        cardRepository: i.get(),
        invoiceRepository: i.get(),
      ),
    );
    i.addLazySingleton<IGetExpenseTypes>(() => GetExpenseTypes(i.get()));
    i.addLazySingleton<CreditCardStore>(
      () => CreditCardStore(manageCreditCard: i.get()),
    );
    i.addLazySingleton<ExpenseTypeStore>(() => ExpenseTypeStore(i.get()));
  }

  @override
  void routes(RouteManager r) {
    r.add(ChildRoute('/', child: (context) => HomeScreen()));
    r.add(ChildRoute('/expense/add',
        child: (context) => const CreateExpenseScreen()));
  }
}
