import 'package:flutter_modular/flutter_modular.dart'
    show RouteManageExt, TransitionType, RouteManager;

import '../bind_service_provider.dart';
import 'routes.dart';
import 'src/domain/entities/credit_card.dart';
import 'src/domain/entities/expense.dart';
import 'src/domain/entities/income.dart';
import 'src/domain/models/expense_model.dart';
import 'src/domain/models/income_model.dart';
import 'src/presenter/controllers/expense_store.dart';
import 'src/presenter/controllers/income_store.dart';
import 'src/presenter/screens/screens.dart';

abstract final class RegisterRoutes {
  static void register(RouteManager r) {
    _registerIndependentRoutes(r);
    _registerIncomeRoutes(r);
    _registerExpenseRoutes(r);
    _registerCardRoutes(r);
  }

  ///Registers the routes that don't have a prefix. For example: '/', '/graphics'
  static void _registerIndependentRoutes(RouteManager r) {
    r.child(
      UnmodularFormatFinanceRoutes.home,
      child: (context) => HomeScreen(
        incomeStore: _resolve(),
        expenseStore: _resolve(),
        creditCardStore: _resolve(),
        accountStore: _resolve(),
      ),
    );

    r.child(
      UnmodularFormatFinanceRoutes.charts,
      child: (context) => GraphicsScreen(
        graphsStore: _resolve(),
        accountStore: _resolve(),
        balanceStore: _resolve(),
      ),
    );
  }

  static void _registerIncomeRoutes(RouteManager r) {
    r.child(
      UnmodularFormatFinanceRoutes.incomes,
      child: (context) => IncomesScreen(
        incomeStore: _resolve(),
        accountStore: _resolve(),
        categoryStore: _resolve(),
      ),
    );

    r.child(
      UnmodularFormatFinanceRoutes.addIncome,
      child: (context) => CreateIncomeScreen(
        accountStore: _resolve(),
        incomeStore: _resolve(),
        categoryStore: _resolve(),
      ),
    );

    r.child(
      UnmodularFormatFinanceRoutes.updateIncome,
      child: (ctx) => EditIncomeScreen(
        incomeStore: _resolve(),
        categoryStore: _resolve(),
      ),
    );

    r.child(
      UnmodularFormatFinanceRoutes.payIncome,
      child: (context) {
        IncomeModel model = r.args.data['model'];
        BindServiceProvider.get<IncomeStore>().setSelectedModel(model);

        return PaymentScreen<Income, IncomeModel>(
          model: model,
          store: BindServiceProvider.get<IncomeStore>(),
          accountStore: _resolve(),
          balanceStore: _resolve(),
          cardStore: _resolve(),
        );
      },
    );
  }

  static void _registerExpenseRoutes(RouteManager r) {
    r.child(
      UnmodularFormatFinanceRoutes.expenses,
      child: (context) => ExpensesScreen(
        accountStore: _resolve(),
        categoryStore: _resolve(),
        expenseStore: _resolve(),
      ),
    );

    r.child(
      UnmodularFormatFinanceRoutes.addExpense,
      child: (context) => CreateExpenseScreen(
        accountStore: _resolve(),
        expenseStore: _resolve(),
        categoryStore: _resolve(),
      ),
    );

    r.child(
      UnmodularFormatFinanceRoutes.updateExpense,
      child: (ctx) => EditExpenseScreen(
        expenseStore: _resolve(),
        categoryStore: _resolve(),
      ),
    );

    r.child(UnmodularFormatFinanceRoutes.payExpense, child: (context) {
      ExpenseModel model = r.args.data['model'];

      return PaymentScreen<Expense, ExpenseModel>(
        model: model,
        store: BindServiceProvider.get<ExpenseStore>(),
        accountStore: _resolve(),
        balanceStore: _resolve(),
        cardStore: _resolve(),
      );
    });
  }

  static void _registerCardRoutes(RouteManager r) {
    r.child(
      UnmodularFormatFinanceRoutes.cards,
      child: (context) => CreditCardsScreen(
        cardStore: _resolve(),
      ),
      transition: TransitionType.scale,
    );

    r.child(
      UnmodularFormatFinanceRoutes.addCard,
      child: (context) => CreateCreditCardScreen(
        accountStore: _resolve(),
        cardStore: _resolve(),
      ),
    );
    r.child(
      UnmodularFormatFinanceRoutes.updateCard,
      child: (ctx) => EditCreditCardScreen(
        card: r.args.data as CreditCard,
        cardStore: _resolve(),
      ),
    );
  }

  ///Resolve the dependency that a screen needs. Is just a shortcut to
  ///```dart
  ///BindServiceProvider.get();
  ///```
  static T _resolve<T extends Object>() => BindServiceProvider.get<T>();
}
