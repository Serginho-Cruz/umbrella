import '../../domain/entities/account.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/frequency.dart';

abstract interface class ExpenseDatasource {
  Future<int> create(Expense expense, Account account);
  Future<void> update(Expense newExpense);
  Future<List<Expense>> getAllOf({
    required int month,
    required int year,
    required Account account,
  });
  Future<List<Expense>> getByFrequency(Frequency frequency, Account account);
  Future<List<Expense>> getByFrequencyInRange({
    required Frequency frequency,
    required Account account,
    required Date inferiorLimit,
    required Date upperLimit,
  });
  Future<void> delete(Expense expense);
}
