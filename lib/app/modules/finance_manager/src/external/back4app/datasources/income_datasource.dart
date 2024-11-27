import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/income_datasource.dart';

import '../functions.dart';
import '../mappers/account_mapper.dart';
import '../mappers/income_mapper.dart';
import '../parse_objects.dart';

class Back4AppIncomeDatasource implements IncomeDatasource {
  @override
  Future<String> create(Income income) async {
    var object = IncomeMapper.toParse(income, noId: true);

    var response = await object.create();

    if (isResponseSuccesful(response)) {
      return (response.results!.first as ParseObject).objectId!;
    }

    throw extractFail(response);
  }

  @override
  Future<List<Income>> getAllOf({
    required Account account,
    required int month,
    required int year,
  }) async {
    var query = QueryBuilder(IncomeObject());

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
      return (response.results as List<ParseObject>)
          .map(IncomeMapper.fromParse)
          .toList();
    }

    throw extractFail(response);
  }

  @override
  Future<List<Income>> getByFrequency(
    Frequency frequency,
    Account account,
  ) async {
    var query = QueryBuilder(IncomeObject());

    query.whereEqualTo('frequency', frequency.toInt());
    query.whereEqualTo('account', AccountMapper.toParse(account));

    query.includeObject(['account', 'category']);

    query.orderByAscending('overdueDate');

    var response = await query.query();

    if (isResponseSuccesful(response)) {
      if (response.results == null) return [];

      return (response.results! as List<ParseObject>)
          .map(IncomeMapper.fromParse)
          .toList();
    }

    throw extractFail(response);
  }

  @override
  Future<List<Income>> getByFrequencyInRange({
    required Date inferiorLimit,
    required Date upperLimit,
    required Frequency frequency,
    required Account account,
  }) async {
    var query = QueryBuilder(ExpenseObject());

    query.whereEqualTo('frequency', frequency.toInt());
    query.whereEqualTo('account', AccountMapper.toParse(account));
    query.whereGreaterThanOrEqualsTo('overdueDate', inferiorLimit.toDateTime());
    query.whereLessThanOrEqualTo('overdueDate', upperLimit.toDateTime());

    query.orderByAscending('overdueDate');

    query.includeObject(['account', 'category']);

    var response = await query.query();

    if (isResponseSuccesful(response)) {
      if (response.results == null) return [];
      return (response.results! as List<ParseObject>)
          .map(IncomeMapper.fromParse)
          .toList();
    }

    throw extractFail(response);
  }

  @override
  Future<void> update(Income newIncome) async {
    var object = IncomeMapper.toParse(newIncome);

    var response = await object.update();

    if (isResponseSuccesful(response)) {
      return;
    }

    throw extractFail(response);
  }

  @override
  Future<void> delete(Income income) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
