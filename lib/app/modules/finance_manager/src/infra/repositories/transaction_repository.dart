import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/transaction_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/transaction.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/transaction_datasource.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDatasource _datasource;

  TransactionRepositoryImpl(this._datasource);

  @override
  AsyncResult<int, Fail> register(
    Transaction transaction,
    Account account,
  ) async {
    try {
      var id = await _datasource.register(transaction, account);
      return Success(id);
    } on Fail catch (f) {
      return Failure(f);
    } catch (_) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<List<Transaction>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    try {
      var transactions = await _datasource.getAllOf(
        account: account,
        month: month,
        year: year,
      );
      return Success(transactions);
    } on Fail catch (f) {
      return Failure(f);
    } catch (_) {
      return Failure(GenericError());
    }
  }

  @override
  AsyncResult<Unit, Fail> deleteAllOf(Paiyable paiyable) async {
    try {
      await _datasource.deleteAllOf(paiyable);
      return const Success(unit);
    } on Fail catch (f) {
      return Failure(f);
    } catch (_) {
      return Failure(GenericError());
    }
  }
}
