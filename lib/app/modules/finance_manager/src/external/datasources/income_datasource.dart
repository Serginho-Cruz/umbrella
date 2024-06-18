import '../../domain/entities/account.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/frequency.dart';
import '../../domain/entities/income.dart';
import '../../errors/errors.dart';
import '../../infra/datasources/income_datasource.dart';

class TemporaryIncomeDatasource implements IncomeDatasource {
  final Map<int, List<Income>> _incomes = {
    1: [
      Income(
        id: 1,
        name: "Salário",
        totalValue: 1250.00,
        paidValue: 0.00,
        remainingValue: 1250.00,
        dueDate: Date(day: 12, month: 5, year: 2024),
        paymentDate: null,
        category:
            const Category(id: 11, name: 'Outros', icon: 'icons/outros.png'),
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
        category:
            const Category(id: 11, name: 'Outros', icon: 'icons/outros.png'),
        frequency: Frequency.none,
      ),
      Income(
        id: 3,
        name: "Décimo Terceiro",
        totalValue: 1200.00,
        paidValue: 0.00,
        remainingValue: 1200.00,
        dueDate: Date(day: 20, month: 12, year: 2024),
        category:
            const Category(id: 11, name: 'Outros', icon: 'icons/outros.png'),
        frequency: Frequency.yearly,
      ),
      Income(
        id: 6,
        name: "Férias",
        totalValue: 2000.00,
        paidValue: 0.00,
        remainingValue: 2000.00,
        dueDate: Date(day: 6, month: 6, year: 2024),
        category:
            const Category(id: 11, name: 'Outros', icon: 'icons/outros.png'),
        frequency: Frequency.yearly,
      ),
    ],
    2: [
      Income(
        id: 4,
        name: 'Bico de Motoboy',
        totalValue: 300.00,
        paidValue: 300.00,
        remainingValue: 0.00,
        dueDate: Date.today(),
        paymentDate: Date.today(),
        category:
            const Category(id: 11, name: 'Outros', icon: 'icons/outros.png'),
        frequency: Frequency.none,
      ),
      Income(
        id: 5,
        name: 'Bico de Garçom',
        totalValue: 900.00,
        paidValue: 0.00,
        remainingValue: 900.00,
        dueDate: Date(day: 20, month: 5, year: 2024),
        category:
            const Category(id: 11, name: 'Outros', icon: 'icons/outros.png'),
        frequency: Frequency.none,
      ),
    ],
    3: [
      Income(
          id: 7,
          name: 'Transferência',
          totalValue: 2000.00,
          paidValue: 0.00,
          remainingValue: 2000.00,
          frequency: Frequency.yearly,
          dueDate: Date(day: 12, month: 1, year: 2025),
          category:
              const Category(id: 11, name: 'Outros', icon: 'icons/outros.png')),
    ],
  };

  @override
  Future<int> create(Income income, Account account) {
    List<Income> all = [];

    for (var list in _incomes.values) {
      for (var income in list) {
        all.add(income.copyWith());
      }
    }

    all.sort((e1, e2) => e1.id.compareTo(e2.id));
    int newId = all.last.id + 1;

    Income newIncome = income.copyWith(id: newId);

    _incomes.update(account.id, (value) => value..add(newIncome),
        ifAbsent: () => [newIncome]);

    return Future.value(newId);
  }

  @override
  Future<void> update(Income newIncome) async {
    int? index;
    int? accountId;

    for (var accId in _incomes.keys) {
      for (var element in _incomes[accId]!.indexed) {
        if (element.$2.id == newIncome.id) {
          index = element.$1;
          accountId = accId;
          break;
        }
      }

      if (index != null) break;
    }

    if (index == null || accountId == null) throw GenericError();

    _incomes[accountId]!.removeAt(index);
    _incomes[accountId]!.insert(index, newIncome);
  }

  @override
  Future<List<Income>> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) {
    var incomes = _incomes
        .putIfAbsent(account.id, () => [])
        .where((e) => e.dueDate.month == month && e.dueDate.year == year);

    return Future.delayed(const Duration(seconds: 2), () {
      return incomes.toList();
    });
  }

  @override
  Future<void> delete(Income income) async {
    int? index;
    int? accountId;

    for (var accId in _incomes.keys) {
      for (var element in _incomes[accId]!.indexed) {
        if (element.$2.id == income.id) {
          index = element.$1;
          accountId = accId;
          break;
        }
      }

      if (index != null) break;
    }

    if (index == null || accountId == null) throw GenericError();

    _incomes[accountId]!.removeAt(index);
  }

  @override
  Future<List<Income>> getByFrequency(Frequency frequency, Account account) {
    var incomes = _incomes
        .putIfAbsent(account.id, () => [])
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
    var incomes = _incomes.putIfAbsent(account.id, () => []).where((e) {
      return e.frequency == frequency &&
          e.dueDate.isAfter(inferiorLimit) &&
          e.dueDate.isBefore(upperLimit);
    });

    return Future.value(incomes.toList());
  }
}
