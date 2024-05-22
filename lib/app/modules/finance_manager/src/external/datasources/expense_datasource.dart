import '../../domain/entities/account.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_type.dart';
import '../../domain/entities/frequency.dart';
import '../../errors/errors.dart';
import '../../infra/datasources/expense_datasource.dart';

class TemporaryExpenseDatasource implements ExpenseDatasource {
  final Map<Account, List<Expense>> _expenses = {
    const Account(
      id: 1,
      name: 'Conta Padrão',
      actualBalance: 0.00,
      isDefault: true,
    ): [
      Expense(
        id: 1,
        name: "Conta de Luz",
        totalValue: 250.00,
        paidValue: 0.00,
        remainingValue: 250.00,
        dueDate: Date(day: 12, month: 5, year: 2024),
        paymentDate: null,
        type: const ExpenseType(id: 1, icon: 'icons/conta.png', name: 'Conta'),
        frequency: Frequency.monthly,
      ),
      Expense(
        id: 2,
        name: "Compras do Mês",
        totalValue: 609.23,
        paidValue: 609.23,
        remainingValue: 0.00,
        dueDate: Date(day: 10, month: 5, year: 2024),
        paymentDate: Date(day: 10, month: 5, year: 2024),
        type: const ExpenseType(
          id: 2,
          icon: 'icons/alimentacao.png',
          name: 'Alimentação',
        ),
        frequency: Frequency.none,
      ),
      Expense(
        id: 3,
        name: "Dados Móveis",
        totalValue: 20.00,
        paidValue: 0.00,
        remainingValue: 20.00,
        dueDate: Date(day: 9, month: 5, year: 2024),
        paymentDate: null,
        type:
            const ExpenseType(id: 5, icon: 'icons/outros.png', name: 'Outros'),
        frequency: Frequency.monthly,
      ),
    ],
    const Account(id: 2, name: 'Banco do Brasil', actualBalance: 200.00): [
      Expense(
        id: 4,
        name: 'Roupas Novas',
        totalValue: 1500.00,
        paidValue: 1500.00,
        remainingValue: 0.00,
        dueDate: Date.today(),
        paymentDate: Date.today(),
        type: const ExpenseType(
            id: 1, name: "Vestimenta", icon: 'icons/vestimenta.png'),
        frequency: Frequency.none,
      ),
      Expense(
        id: 4,
        name: 'Aluguel',
        totalValue: 900.00,
        paidValue: 0.00,
        remainingValue: 900.00,
        dueDate: Date(day: 20, month: 5, year: 2024),
        type: const ExpenseType(
            id: 4, name: "Moradia", icon: 'icons/moradia.png'),
        frequency: Frequency.monthly,
      ),
    ],
    const Account(id: 3, name: 'Itaú', actualBalance: 156.32): [
      Expense(
        id: 5,
        name: 'IPVA',
        totalValue: 2000.00,
        paidValue: 0.00,
        remainingValue: 2000.00,
        frequency: Frequency.yearly,
        dueDate: Date(day: 12, month: 1, year: 2025),
        type: const ExpenseType(
          id: 2,
          name: 'Outros',
          icon: 'icons/outros.png',
        ),
      ),
    ],
  };

  @override
  Future<int> create(Expense expense, Account account) {
    var expenses = _expenses.values.reduce((all, list) => all..addAll(list));

    expenses.sort((e1, e2) => e1.id.compareTo(e2.id));
    int newId = expenses.last.id + 1;

    _expenses.putIfAbsent(account, () => []).add(expense.copyWith(id: newId));
    return Future.value(newId);
  }

  @override
  Future<void> update(Expense newExpense) async {
    int? index;
    Account? account;

    for (var acc in _expenses.keys) {
      for (var element in _expenses[acc]!.indexed) {
        if (element.$2.id == newExpense.id) {
          index = element.$1;
          account = acc;
          break;
        }
      }

      if (index != null) break;
    }

    if (index == null || account == null) throw GenericError();

    _expenses[account]!.removeAt(index);
    _expenses[account]!.insert(index, newExpense);
  }

  @override
  Future<List<Expense>> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) {
    var expenses = _expenses
        .putIfAbsent(account, () => [])
        .where((e) => e.dueDate.month == month && e.dueDate.year == year);

    return Future.delayed(const Duration(seconds: 4), () {
      return expenses.toList();
    });
  }

  @override
  Future<void> delete(Expense expense) async {
    int? index;
    Account? account;

    for (var acc in _expenses.keys) {
      for (var element in _expenses[acc]!.indexed) {
        if (element.$2.id == expense.id) {
          index = element.$1;
          account = acc;
          break;
        }
      }

      if (index != null) break;
    }

    if (index == null || account == null) throw GenericError();

    _expenses[account]!.removeAt(index);
  }

  @override
  Future<List<Expense>> getByFrequency(Frequency frequency, Account account) {
    var expenses = _expenses
        .putIfAbsent(account, () => [])
        .where((e) => e.frequency == frequency);

    return Future.delayed(const Duration(seconds: 4), () {
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
    var expenses = _expenses.putIfAbsent(account, () => []).where((e) {
      return e.frequency == frequency &&
          e.dueDate.isAfter(inferiorLimit) &&
          e.dueDate.isBefore(upperLimit);
    });

    return Future.value(expenses.toList());
  }
}
