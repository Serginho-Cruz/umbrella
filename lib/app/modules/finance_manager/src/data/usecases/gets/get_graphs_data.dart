import 'package:result_dart/result_dart.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/category.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/round.dart';

import '../../../domain/entities/date.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/income.dart';
import '../../../domain/entities/paiyable.dart';
import '../../../domain/entities/payment_record.dart';
import '../../../domain/models/status.dart';
import '../../../domain/usecases/gets/get_balance.dart';
import '../../../domain/usecases/gets/get_graphs_data.dart';
import '../../../domain/usecases/sorts/sort_payment_records.dart';
import '../../repositories/expense_repository.dart';
import '../../repositories/income_repository.dart';
import '../../repositories/payment_record_repository.dart';

class GetGraphsDataImpl implements GetGraphsData {
  final ExpenseRepository _expenseRepository;
  final IncomeRepository _incomeRepository;
  final GetBalance _getBalance;
  final SortPaymentRecords _sortRecords;
  final PaymentRecordRepository _recordRepository;

  GetGraphsDataImpl({
    required ExpenseRepository expenseRepository,
    required IncomeRepository incomeRepository,
    required GetBalance getBalance,
    required SortPaymentRecords sortRecords,
    required PaymentRecordRepository recordRepository,
  })  : _expenseRepository = expenseRepository,
        _incomeRepository = incomeRepository,
        _getBalance = getBalance,
        _sortRecords = sortRecords,
        _recordRepository = recordRepository;

  @override
  AsyncResult<Map<Category, double>, Fail> valueOfEachExpenseCategory({
    required List<Account> accounts,
    required int month,
    required int year,
  }) async {
    var result = await _fetchPaiyables<Expense>(accounts, month, year);

    if (result.isError()) return result.map((_) => const {});

    Map<Category, double> map = _extractInformation<Category, Expense>(
      paiyables: result.getOrDefault(<Expense>[]),
      extractValue: (p) => p.category,
    );

    return Success(map);
  }

  @override
  AsyncResult<Map<Category, double>, Fail> valueOfEachIncomeCategory({
    required List<Account> accounts,
    required int month,
    required int year,
  }) async {
    var result = await _fetchPaiyables<Income>(accounts, month, year);

    if (result.isError()) return result.map((_) => const {});

    Map<Category, double> map = _extractInformation<Category, Income>(
      paiyables: result.getOrDefault(<Income>[]),
      extractValue: (p) => p.category,
    );

    return Success(map);
  }

  @override
  AsyncResult<Map<Status, double>, Fail> valueForEachExpenseStatus({
    required List<Account> accounts,
    required int month,
    required int year,
  }) async {
    var result = await _fetchPaiyables<Expense>(accounts, month, year);

    if (result.isError()) return result.map((_) => const {});

    Map<Status, double> map = _extractInformation<Status, Expense>(
      paiyables: result.getOrDefault(<Expense>[]),
      extractValue: (p) => StatusUtils.resolveForPaiyable(p),
    );

    return Success(map);
  }

  @override
  AsyncResult<Map<Status, double>, Fail> valueForEachIncomeStatus({
    required List<Account> accounts,
    required int month,
    required int year,
  }) async {
    var result = await _fetchPaiyables<Income>(accounts, month, year);

    if (result.isError()) return result.map((_) => const {});

    Map<Status, double> map = _extractInformation<Status, Income>(
      paiyables: result.getOrDefault(<Income>[]),
      extractValue: (p) => StatusUtils.resolveForPaiyable(p),
    );

    return Success(map);
  }

  @override
  AsyncResult<Map<PaymentMethod, double>, Fail> valuePaidWithEachMethod({
    required List<Account> accounts,
    required int month,
    required int year,
  }) {
    // TODO: implement valuePaidWithEachMethod
    throw UnimplementedError();
  }

  @override
  AsyncResult<Map<int, double>, Fail> balanceEvolution({
    required List<Account> accounts,
    required int month,
    required int year,
  }) async {
    double initialBalance = 0;
    List<PaymentRecord> records = [];

    for (var account in accounts) {
      var recordsResult = await _recordRepository.getAllOf(
        month: month,
        year: year,
        account: account,
      );

      var balanceResult = await _getBalance.initialOf(
        month: month,
        year: year,
        account: account,
      );

      if (balanceResult.isError()) return balanceResult.pure({});
      if (recordsResult.isError()) return recordsResult.pure({});

      initialBalance += balanceResult.getOrDefault(0.00);
      records.addAll(recordsResult.getOrDefault([]));
    }

    int todayDay = Date.today().day;

    List<PaymentRecord> sorted = _sortRecords.byPaymentDate(records: records);

    var balancePerDay = <int, double>{};
    double balance = initialBalance;

    for (int i = 1; i <= todayDay; i++) {
      Date day = Date(day: i, month: month, year: year);
      var dayRecords = sorted.where((rec) => rec.date == day).toList();

      for (var record in dayRecords) {
        balance += record.paiyable is Income ? record.value : -record.value;
      }

      balancePerDay[i] = balance;
    }

    return Success(balancePerDay);
  }

  AsyncResult<List<T>, Fail> _fetchPaiyables<T extends Paiyable>(
    List<Account> accs,
    int month,
    int year,
  ) async {
    List<T> paiyables = [];

    var fetchFunction = paiyables is List<Expense>
        ? _expenseRepository.getAllOf
        : _incomeRepository.getAllOf;

    for (var account in accs) {
      Result<List<T>, Fail> result = await fetchFunction(
        account: account,
        month: month,
        year: year,
      ) as Result<List<T>, Fail>;

      if (result.isError()) return result.map((_) => <T>[]);

      paiyables.addAll(result.getOrDefault(<T>[]));
    }

    return Success(paiyables);
  }

  Map<T, double> _extractInformation<T, P extends Paiyable>({
    required List<P> paiyables,
    required T Function(P) extractValue,
    double Function(P)? extractAmount,
  }) {
    extractAmount ??= (p) => p.totalValue;

    Map<T, double> map = {};

    for (var paiyable in paiyables) {
      T information = extractValue(paiyable);
      double amount = paiyable.totalValue;

      map.update(
        information,
        (value) => (value + amount).roundToDecimal(),
        ifAbsent: () => amount.roundToDecimal(),
      );
    }

    return map..removeWhere((_, amount) => amount == 0);
  }
}
