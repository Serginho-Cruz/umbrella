import 'package:flutter_modular/flutter_modular.dart';
import 'package:umbrella_echonomics/app/modules/auth/auth_module.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/screens/create_credit_card_screen.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/screens/incomes_screen.dart';

import 'controllers_bindings.dart';
import 'datasources_bindings.dart';
import 'repositories_bindings.dart';
import 'routes.dart';
import 'src/presenter/screens/expenses_screen.dart';
import 'usecases_bindings.dart';

class FinanceManagerModule extends Module {
  @override
  List<Module> get imports => [AuthModule()];

  @override
  void binds(Injector i) {
    DatasourcesBindings.bind(i);
    RepositoriesBindings.bind(i);
    UsecasesBindings.bind(i);
    ControllersBindings.bind(i);
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
        '/income',
        child: (context) => IncomesScreen(
          incomeStore: Modular.get(),
          accountStore: Modular.get(),
          categoryStore: Modular.get(),
        ),
      ),
    );
    r.add(
      ChildRoute(
        '/expense',
        child: (context) => ExpensesScreen(
          accountStore: Modular.get(),
          categoryStore: Modular.get(),
          expenseStore: Modular.get(),
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
          categoryStore: Modular.get(),
        ),
      ),
    );
    r.add(
      ChildRoute(
        '/income/add',
        child: (context) => CreateIncomeScreen(
          accountStore: Modular.get(),
          incomeStore: Modular.get(),
          categoryStore: Modular.get(),
        ),
      ),
    );
    r.add(
      ChildRoute(
        '/card/add',
        child: (context) => CreateCreditCardScreen(
          accountStore: Modular.get(),
          cardStore: Modular.get(),
        ),
      ),
    );
  }
}
