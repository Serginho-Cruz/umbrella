import '../../../domain/entities/account.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/date.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/frequency.dart';
import '../../../errors/errors.dart';
import '../../../infra/datasources/expense_datasource.dart';

class TemporaryExpenseDatasource implements ExpenseDatasource {
  final Map<int, List<Expense>> _expenses = {
    1: [
      Expense(
        id: 1,
        name: "Conta de Luz",
        totalValue: 250.00,
        paidValue: 0.00,
        remainingValue: 250.00,
        dueDate: Date.today().copyWith(day: 12),
        paymentDate: null,
        category: const Category(id: 1, icon: 'icons/conta.png', name: 'Conta'),
        frequency: Frequency.monthly,
        account: const Account(
          id: 1,
          isDefault: true,
          actualBalance: 200.0,
          name: 'Conta Padrão',
        ),
      ),
      Expense(
        id: 2,
        name: "Compras do Mês",
        totalValue: 609.23,
        paidValue: 609.23,
        remainingValue: 0.00,
        dueDate: Date(day: 10, month: 6, year: 2024),
        paymentDate: Date(day: 10, month: 6, year: 2024),
        category: const Category(
          id: 2,
          icon: 'icons/alimentacao.png',
          name: 'Alimentação',
        ),
        frequency: Frequency.none,
        account: const Account(
          id: 1,
          isDefault: true,
          actualBalance: 200.0,
          name: 'Conta Padrão',
        ),
      ),
      Expense(
        id: 3,
        name: "Dados Móveis",
        totalValue: 20.00,
        paidValue: 0.00,
        remainingValue: 20.00,
        dueDate: Date.today().copyWith(day: 6),
        paymentDate: null,
        category:
            const Category(id: 5, icon: 'icons/outros.png', name: 'Outros'),
        frequency: Frequency.monthly,
        account: const Account(
          id: 1,
          isDefault: true,
          actualBalance: 200.0,
          name: 'Conta Padrão',
        ),
      ),
    ],
    2: [
      Expense(
        id: 4,
        name: 'Roupas Novas',
        totalValue: 1500.00,
        paidValue: 1500.00,
        remainingValue: 0.00,
        dueDate: Date.today(),
        paymentDate: Date.today(),
        category: const Category(
            id: 1, name: "Vestimenta", icon: 'icons/vestimenta.png'),
        frequency: Frequency.none,
        account: const Account(
            id: 2, name: 'Banco do Brasil', actualBalance: 200.00),
      ),
      Expense(
        id: 5,
        name: 'Aluguel',
        totalValue: 900.00,
        paidValue: 0.00,
        remainingValue: 900.00,
        dueDate:Date.today().copyWith(day: 18),
        category:
            const Category(id: 4, name: "Moradia", icon: 'icons/moradia.png'),
        frequency: Frequency.monthly,
        account: const Account(
            id: 2, name: 'Banco do Brasil', actualBalance: 200.00),
      ),
    ],
    3: [
      Expense(
        id: 6,
        name: 'IPVA',
        totalValue: 2000.00,
        paidValue: 0.00,
        remainingValue: 2000.00,
        frequency: Frequency.yearly,
        dueDate: Date(day: 12, month: 1, year: 2025),
        category: const Category(
          id: 2,
          name: 'Outros',
          icon: 'icons/outros.png',
        ),
        account: const Account(id: 3, name: 'Itaú', actualBalance: 156.32),
      ),
    ],
  };

  @override
  Future<int> create(Expense expense) {
    List<Expense> all = [];

    for (var list in _expenses.values) {
      for (var expense in list) {
        all.add(expense.copyWith());
      }
    }

    all.sort((e1, e2) => e1.id.compareTo(e2.id));
    int newId = all.last.id + 1;

    _expenses
        .putIfAbsent(expense.account.id, () => [])
        .add(expense.copyWith(id: newId));
    return Future.value(newId);
  }

  @override
  Future<void> update(Expense newExpense) async {
    int? index;
    int? accountId;

    for (var accId in _expenses.keys) {
      for (var element in _expenses[accId]!.indexed) {
        if (element.$2.id == newExpense.id) {
          index = element.$1;
          accountId = accId;
          break;
        }
      }

      if (index != null) break;
    }

    if (index == null || accountId == null) throw GenericError();

    _expenses[accountId]!.removeAt(index);

    if (!_expenses.containsKey(newExpense.account.id)) {
      _expenses.putIfAbsent(newExpense.account.id, () => [newExpense]);
      return;
    }

    _expenses.update(newExpense.account.id, (exps) => exps..add(newExpense));
  }

  @override
  Future<List<Expense>> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) {
    var allFromAccount = _expenses.putIfAbsent(account.id, () => []);

    var fromMonth = allFromAccount
        .where((e) =>
            e.dueDate.month == month &&
            e.dueDate.year == year &&
            e.frequency != Frequency.monthly)
        .toList();

    var monthly = allFromAccount.where((e) => e.frequency == Frequency.monthly);

    var monthlyCorrectedDates = <Expense>[];

    for (var element in monthly) {
      monthlyCorrectedDates.add(
        element.copyWith(
          dueDate: element.dueDate.copyWith(month: month, year: year),
        ),
      );
    }

    var expenses = fromMonth..addAll(monthlyCorrectedDates);

    return Future.delayed(const Duration(seconds: 2), () {
      return expenses;
    });
  }

  @override
  Future<void> delete(Expense expense) async {
    int? index;
    int? accountId;

    for (var accId in _expenses.keys) {
      for (var element in _expenses[accId]!.indexed) {
        if (element.$2.id == expense.id) {
          index = element.$1;
          accountId = accId;
          break;
        }
      }

      if (index != null) break;
    }

    if (index == null || accountId == null) throw GenericError();

    _expenses[accountId]!.removeAt(index);
  }

  @override
  Future<List<Expense>> getByFrequency(Frequency frequency, Account account) {
    var expenses = _expenses
        .putIfAbsent(account.id, () => [])
        .where((e) => e.frequency == frequency);

    return Future.delayed(const Duration(seconds: 1), () {
      return expenses.toList();
    });
  }

  @override
  Future<List<Expense>> getByFrequencyInRange({
    required Frequency frequency,
    required Account account,
    required Date inferiorLimit,
    required Date upperLimit,
  }) {
    var expenses = _expenses.putIfAbsent(account.id, () => []).where((e) {
      return e.frequency == frequency &&
          e.dueDate.isAfter(inferiorLimit) &&
          e.dueDate.isBefore(upperLimit);
    });

    return Future.value(expenses.toList());
  }
}
