import 'package:flutter_modular/flutter_modular.dart';
import 'package:umbrella_echonomics/app/modules/auth/auth_module.dart';

import 'bindings/controllers_bindings.dart';
import 'bindings/datasources_bindings.dart';
import 'bindings/repositories_bindings.dart';
import 'routes.dart';
import 'src/domain/entities/credit_card.dart';
import 'src/domain/entities/expense.dart';
import 'src/domain/entities/income.dart';
import 'bindings/usecases_bindings.dart';

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
    r.child(
      '/',
      transition: TransitionType.scale,
      child: (context) => HomeScreen(
        incomeStore: Modular.get(),
        expenseStore: Modular.get(),
        creditCardStore: Modular.get(),
        accountStore: Modular.get(),
        balanceStore: Modular.get(),
      ),
    );

    r.child(
      '/income',
      child: (context) => IncomesScreen(
        incomeStore: Modular.get(),
        accountStore: Modular.get(),
        categoryStore: Modular.get(),
        balanceStore: Modular.get(),
      ),
    );
    r.child(
      '/expense',
      child: (context) => ExpensesScreen(
        accountStore: Modular.get(),
        balanceStore: Modular.get(),
        categoryStore: Modular.get(),
        expenseStore: Modular.get(),
      ),
    );

    r.child(
      '/card/update',
      child: (ctx) => EditCreditCardScreen(
        card: r.args.data as CreditCard,
        accountStore: Modular.get(),
        balanceStore: Modular.get(),
        cardStore: Modular.get(),
      ),
    );

    r.child(
      '/expense/update',
      child: (ctx) => EditExpenseScreen(
        expenseStore: Modular.get(),
        categoryStore: Modular.get(),
        accountStore: Modular.get(),
        balanceStore: Modular.get(),
        expense: r.args.data as Expense,
      ),
    );

    r.child(
      '/income/update',
      child: (ctx) => EditIncomeScreen(
        income: r.args.data as Income,
        incomeStore: Modular.get(),
        categoryStore: Modular.get(),
        accountStore: Modular.get(),
        balanceStore: Modular.get(),
      ),
    );

    r.child(
      '/card',
      child: (context) => CreditCardsScreen(
        cardStore: Modular.get(),
        accountStore: Modular.get(),
        balanceStore: Modular.get(),
      ),
      transition: TransitionType.scale,
    );
    r.child(
      '/expense/add',
      child: (context) => CreateExpenseScreen(
        accountStore: Modular.get(),
        balanceStore: Modular.get(),
        cardStore: Modular.get(),
        expenseStore: Modular.get(),
        categoryStore: Modular.get(),
      ),
    );
    r.child(
      '/income/add',
      child: (context) => CreateIncomeScreen(
        accountStore: Modular.get(),
        balanceStore: Modular.get(),
        incomeStore: Modular.get(),
        categoryStore: Modular.get(),
      ),
    );
    r.child(
      '/card/add',
      child: (context) => CreateCreditCardScreen(
        accountStore: Modular.get(),
        balanceStore: Modular.get(),
        cardStore: Modular.get(),
      ),
    );
  }
}
