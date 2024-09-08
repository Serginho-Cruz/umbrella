import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/expense_datasource.dart';

class Back4AppExpenseDatasource implements ExpenseDatasource {
  @override
  Future<String> create(Expense expense) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(Expense expense) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Expense>> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) {
    // TODO: implement getAllOf
    throw UnimplementedError();
  }

  @override
  Future<List<Expense>> getByFrequency(
    Frequency frequency,
    Account account,
  ) {
    // TODO: implement getByFrequency
    throw UnimplementedError();
  }

  @override
  Future<List<Expense>> getByFrequencyInRange({
    required Frequency frequency,
    required Account account,
    required Date inferiorLimit,
    required Date upperLimit,
  }) {
    // TODO: implement getByFrequencyInRange
    throw UnimplementedError();
  }

  @override
  Future<void> update(Expense newExpense) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
