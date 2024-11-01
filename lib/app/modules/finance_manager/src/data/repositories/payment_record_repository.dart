import 'package:result_dart/result_dart.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/paiyable.dart';
import '../../domain/entities/payment_record.dart';
import '../../errors/errors.dart';

abstract interface class PaymentRecordRepository {
  AsyncResult<String, Fail> register(PaymentRecord record, Account account);
  AsyncResult<List<PaymentRecord>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  });
  AsyncResult<Unit, Fail> deleteAllOf(Paiyable paiyable);
}
