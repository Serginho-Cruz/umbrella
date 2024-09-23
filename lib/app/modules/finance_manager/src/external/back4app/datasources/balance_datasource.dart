import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/back4app/functions.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/balance_datasource.dart';

import '../../../domain/entities/date.dart';
import '../../../errors/errors.dart';
import '../mappers/account_mapper.dart';
import '../parse_objects.dart';

enum _ChangeAction { increment, decrement }

class Back4AppBalanceDatasource implements BalanceDatasource {
  @override
  Future<void> addToExpected(Account account, double value) =>
      _changeExpected(account, value, changeAction: _ChangeAction.increment);

  @override
  Future<double> getExpectedOf({
    required Account account,
    required int month,
    required int year,
  }) =>
      _fetchBalance(
        account: account,
        month: month,
        year: year,
        returnParameter: 'expected',
      );

  @override
  Future<double> getFinalOf({
    required Account account,
    required int month,
    required int year,
  }) =>
      _fetchBalance(
        account: account,
        month: month,
        year: year,
        returnParameter: 'final',
      );

  @override
  Future<double> getInitialOf({
    required Account account,
    required int month,
    required int year,
  }) =>
      _fetchBalance(
        account: account,
        month: month,
        year: year,
        returnParameter: 'initial',
      );

  @override
  Future<void> setInitialOf({
    required Account account,
    required double value,
    required int month,
    required int year,
  }) async {
    var query = _setUpQuery(account, month, year);
    var response = await query.query();

    if (!isResponseSuccesful(response)) throw extractFail(response);
    if (response.results == null || response.results!.isEmpty) {
      throw const GenericError();
    }

    var object = response.results!.first as ParseObject;

    object.set('initial', value);
    var updateResponse = await object.update();

    if (isResponseSuccesful(updateResponse)) return;
    throw extractFail(updateResponse);
  }

  @override
  Future<void> subtractFromExpected(Account account, double value) =>
      _changeExpected(account, value, changeAction: _ChangeAction.decrement);

  Future<void> _changeExpected(
    Account account,
    double value, {
    required _ChangeAction changeAction,
  }) async {
    Date today = Date.today();

    var query = _setUpQuery(account, today.month, today.year);

    var response = await query.query();

    if (!isResponseSuccesful(response)) {
      throw extractFail(response);
    }

    if (response.results == null || response.results!.isEmpty) {
      throw const GenericError();
    }

    var object = response.results!.first as ParseObject;

    switch (changeAction) {
      case _ChangeAction.increment:
        object.setIncrement('expected', value);
        break;
      case _ChangeAction.decrement:
        object.setDecrement('expected', value);
        break;
    }

    var updateResponse = await object.update();

    if (isResponseSuccesful(updateResponse)) return;
    throw extractFail(updateResponse);
  }

  Future<double> _fetchBalance({
    required Account account,
    required int month,
    required int year,
    required String returnParameter,
  }) async {
    var query = _setUpQuery(account, month, year);

    var response = await query.query();

    if (isResponseSuccesful(response)) {
      if (response.results == null) {
        throw const GenericError();
      }

      return (response.results!.first as ParseObject)
          .get(returnParameter)
          .toDouble();
    }

    throw extractFail(response);
  }

  QueryBuilder _setUpQuery(Account account, int month, int year) {
    var query = QueryBuilder(BalanceObject());
    query.whereEqualTo('account', AccountMapper.toParse(account));
    query.whereEqualTo('monthAndYear', _getMonthAndYearFrom(year, month));
    return query;
  }

  String _getMonthAndYearFrom(int year, int month) {
    String monthText = month.toString();

    if (month < 10) {
      monthText = '0$month';
    }

    return '$year-$monthText';
  }
}
