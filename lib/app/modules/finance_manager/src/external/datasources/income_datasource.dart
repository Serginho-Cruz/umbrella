import '../../domain/entities/account.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/frequency.dart';
import '../../domain/entities/income.dart';
import '../../domain/entities/income_type.dart';
import '../../errors/errors.dart';
import '../../infra/datasources/income_datasource.dart';

class TemporaryIncomeDatasource implements IncomeDatasource {
  final Map<Account, List<Income>> _incomes = {
    const Account(
      id: 1,
      name: 'Conta Padrão',
      actualBalance: 0.00,
      isDefault: true,
    ): [
      Income(
        id: 1,
        name: "Salário",
        totalValue: 1250.00,
        paidValue: 0.00,
        remainingValue: 1250.00,
        dueDate: Date(day: 12, month: 5, year: 2024),
        paymentDate: null,
        type: const IncomeType(id: 1, icon: 'icons/outros.png', name: 'Outros'),
        frequency: Frequency.monthly,
      ),
      Income(
        id: 2,
        name: "Presentes de Aniversário",
        totalValue: 500.00,
        paidValue: 500.00,
        remainingValue: 0.00,
        dueDate: Date(day: 10, month: 5, year: 2024),
        paymentDate: Date(day: 10, month: 5, year: 2024),
        type: const IncomeType(id: 1, icon: 'icons/outros.png', name: 'Outros'),
        frequency: Frequency.none,
      ),
      Income(
        id: 3,
        name: "Décimo Terceiro",
        totalValue: 1200.00,
        paidValue: 0.00,
        remainingValue: 1200.00,
        dueDate: Date(day: 20, month: 12, year: 2024),
        type: const IncomeType(id: 1, icon: 'icons/outros.png', name: 'Outros'),
        frequency: Frequency.yearly,
      ),
      Income(
        id: 6,
        name: "Férias",
        totalValue: 2000.00,
        paidValue: 0.00,
        remainingValue: 2000.00,
        dueDate: Date(day: 6, month: 6, year: 2024),
        type: const IncomeType(id: 1, icon: 'icons/outros.png', name: 'Outros'),
        frequency: Frequency.yearly,
      ),
    ],
    const Account(id: 2, name: 'Banco do Brasil', actualBalance: 200.00): [
      Income(
        id: 4,
        name: 'Bico de Motoboy',
        totalValue: 300.00,
        paidValue: 300.00,
        remainingValue: 0.00,
        dueDate: Date.today(),
        paymentDate: Date.today(),
        type: const IncomeType(id: 1, name: "Outros", icon: 'icons/outros.png'),
        frequency: Frequency.none,
      ),
      Income(
        id: 5,
        name: 'Bico de Garçom',
        totalValue: 900.00,
        paidValue: 0.00,
        remainingValue: 900.00,
        dueDate: Date(day: 20, month: 5, year: 2024),
        type: const IncomeType(id: 1, name: "Outros", icon: 'icons/outros.png'),
        frequency: Frequency.none,
      ),
    ],
    const Account(id: 3, name: 'Itaú', actualBalance: 156.32): [
      Income(
        id: 7,
        name: 'Transferência',
        totalValue: 2000.00,
        paidValue: 0.00,
        remainingValue: 2000.00,
        frequency: Frequency.yearly,
        dueDate: Date(day: 12, month: 1, year: 2025),
        type: const IncomeType(
          id: 2,
          name: 'Outros',
          icon: 'icons/outros.png',
        ),
      ),
    ],
  };

  @override
  Future<int> create(Income income, Account account) {
    var incomes = _incomes.values.reduce((all, list) => all..addAll(list));

    incomes.sort((e1, e2) => e1.id.compareTo(e2.id));
    int newId = incomes.last.id + 1;

    _incomes.putIfAbsent(account, () => []).add(income.copyWith(id: newId));
    return Future.value(newId);
  }

  @override
  Future<void> update(Income newIncome) async {
    int? index;
    Account? account;

    for (var acc in _incomes.keys) {
      for (var element in _incomes[acc]!.indexed) {
        if (element.$2.id == newIncome.id) {
          index = element.$1;
          account = acc;
          break;
        }
      }

      if (index != null) break;
    }

    if (index == null || account == null) throw GenericError();

    _incomes[account]!.removeAt(index);
    _incomes[account]!.insert(index, newIncome);
  }

  @override
  Future<List<Income>> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) {
    var incomes = _incomes
        .putIfAbsent(account, () => [])
        .where((e) => e.dueDate.month == month && e.dueDate.year == year);

    return Future.delayed(const Duration(seconds: 4), () {
      return incomes.toList();
    });
  }

  @override
  Future<void> delete(Income income) async {
    int? index;
    Account? account;

    for (var acc in _incomes.keys) {
      for (var element in _incomes[acc]!.indexed) {
        if (element.$2.id == income.id) {
          index = element.$1;
          account = acc;
          break;
        }
      }

      if (index != null) break;
    }

    if (index == null || account == null) throw GenericError();

    _incomes[account]!.removeAt(index);
  }

  @override
  Future<List<Income>> getByFrequency(Frequency frequency, Account account) {
    var incomes = _incomes
        .putIfAbsent(account, () => [])
        .where((e) => e.frequency == frequency);

    return Future.delayed(const Duration(seconds: 4), () {
      return incomes.toList();
    });
  }

  @override
  Future<List<Income>> getByFrequencyInRange({
    required Frequency frequency,
    required Account account,
    required Date inferiorLimit,
    required Date upperLimit,
  }) {
    var incomes = _incomes.putIfAbsent(account, () => []).where((e) {
      return e.frequency == frequency &&
          e.dueDate.isAfter(inferiorLimit) &&
          e.dueDate.isBefore(upperLimit);
    });

    return Future.value(incomes.toList());
  }
}
