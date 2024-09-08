import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/payment_record_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../domain/entities/payment_record.dart';
import '../datasources/payment_record_datasource.dart';

class PaymentRecordRepositoryImpl implements PaymentRecordRepository {
  final PaymentRecordDatasource _datasource;

  PaymentRecordRepositoryImpl(this._datasource);

  @override
  AsyncResult<String, Fail> register(
    PaymentRecord record,
    Account account,
  ) async {
    try {
      var id = await _datasource.register(record, account);
      return Success(id);
    } on Fail catch (f) {
      return Failure(f);
    } catch (_) {
      return const Failure(GenericError());
    }
  }

  @override
  AsyncResult<List<PaymentRecord>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) async {
    try {
      var records = await _datasource.getAllOf(
        account: account,
        month: month,
        year: year,
      );
      return Success(records);
    } on Fail catch (f) {
      return Failure(f);
    } catch (_) {
      return const Failure(GenericError());
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
      return const Failure(GenericError());
    }
  }
}
