import 'package:result_dart/result_dart.dart';

import '../../../domain/entities/account.dart';
import '../../../domain/entities/payment_record.dart';
import '../../../domain/usecases/gets/get_payment_records.dart';
import '../../../errors/errors.dart';
import '../../repositories/payment_record_repository.dart';

class GetPaymentRecordsOfImpl implements GetPaymentRecordsOf {
  final PaymentRecordRepository repository;

  GetPaymentRecordsOfImpl(this.repository);

  @override
  AsyncResult<List<PaymentRecord>, Fail> call({
    required int month,
    required int year,
    required Account account,
  }) =>
      repository.getAllOf(month: month, year: year, account: account);
}
