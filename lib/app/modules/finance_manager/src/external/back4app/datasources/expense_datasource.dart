import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/expense_datasource.dart';

import '../functions.dart';
import '../mappers/account_mapper.dart';
import '../mappers/expense_mapper.dart';
import '../parse_objects.dart';

class Back4AppExpenseDatasource implements ExpenseDatasource {
  @override
  Future<String> create(Expense expense) async {
    var object = ExpenseMapper.toParse(expense, noId: true);

    var response = await object.create();

    if (isResponseSuccesful(response)) {
      return (response.results!.first as ParseObject).objectId!;
    }

    throw extractFail(response);
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
  }) async {
    var query = QueryBuilder(ExpenseObject());

    DateTime firstDay = DateTime(year, month);
    DateTime lastDay =
        firstDay.copyWith(day: Date.totalDaysOnMonth(month, year));

    query.whereGreaterThanOrEqualsTo('overdueDate', firstDay);
    query.whereLessThanOrEqualTo('overdueDate', lastDay);
    query.whereEqualTo('account', AccountMapper.toParse(account));

    query.includeObject(['account', 'category']);
    query.orderByAscending('overdueDate');

    var response = await query.query();

    if (isResponseSuccesful(response)) {
      if (response.results == null) return [];

      return (response.results! as List<ParseObject>)
          .map(ExpenseMapper.fromParse)
          .toList();
    }

    throw extractFail(response);
  }

  @override
  Future<List<String>> getPersons() async {
    var query = QueryBuilder(ExpenseObject());

    query.whereValueExists('personName', true);
    query.keysToReturn(['personName']);

    var response = await query.distinct('Expense');

    if (isResponseSuccesful(response)) {
      if (response.results == null) return [];

      return (response.results! as List<ParseObject>)
          .map((person) => person.get<String>('personName')!)
          .toList();
    }

    throw extractFail(response);
  }

  @override
  Future<List<Expense>> getByFrequency(
    Frequency frequency,
    Account account,
  ) async {
    var query = QueryBuilder(ExpenseObject());

    query.whereEqualTo('frequency', frequency.toInt());
    query.whereEqualTo('account', AccountMapper.toParse(account));

    query.orderByAscending('overdueDate');

    var response = await query.query();

    if (isResponseSuccesful(response)) {
      if (response.results == null) return [];

      return (response.results! as List<ParseObject>)
          .map(ExpenseMapper.fromParse)
          .toList();
    }

    throw extractFail(response);
  }

  @override
  Future<List<Expense>> getByFrequencyInRange({
    required Frequency frequency,
    required Account account,
    required Date inferiorLimit,
    required Date upperLimit,
  }) async {
    var query = QueryBuilder(ExpenseObject());

    query.whereEqualTo('frequency', frequency.toInt());
    query.whereEqualTo('account', AccountMapper.toParse(account));
    query.whereGreaterThanOrEqualsTo('overdueDate', inferiorLimit.toDateTime());
    query.whereLessThanOrEqualTo('overdueDate', upperLimit.toDateTime());

    query.orderByAscending('overdueDate');

    var response = await query.query();

    if (isResponseSuccesful(response)) {
      if (response.results == null) return [];

      return (response.results! as List<ParseObject>)
          .map(ExpenseMapper.fromParse)
          .toList();
    }

    throw extractFail(response);
  }

  @override
  Future<void> update(Expense newExpense) async {
    var object = ExpenseMapper.toParse(newExpense);

    var response = await object.update();

    if (isResponseSuccesful(response)) {
      return;
    }

    throw extractFail(response);
  }
}
