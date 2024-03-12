import 'package:flutter_modular/flutter_modular.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/icredit_card_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iinvoice_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/manage_credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imanage_credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/datasources/credit_card_datasource.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/repositories/credit_card_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/repositories/invoice_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/credit_card_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/screens/create_expense_screen.dart';

import 'src/infra/datasources/icredit_card_datasource.dart';
import 'src/presenter/screens/home_screen.dart';

class FinanceManagerModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton<ICreditCardDatasource>(() => CreditCardDatasource());
    i.addLazySingleton<ICreditCardRepository>(
      () => CreditCardRepository(creditCardDatasource: i.get()),
    );
    i.addLazySingleton<IInvoiceRepository>(() => InvoiceRepository());
    i.addLazySingleton<IManageCreditCard>(
      () => ManageCreditCard(
        cardRepository: i.get(),
        invoiceRepository: i.get(),
      ),
    );

    i.addLazySingleton<CreditCardStore>(
      () => CreditCardStore(manageCreditCard: i.get()),
    );
  }

  @override
  void routes(RouteManager r) {
    r.add(ChildRoute('/', child: (context) => HomeScreen()));
    r.add(ChildRoute('/expense/create',
        child: (context) => const CreateExpenseScreen()));
  }
}
