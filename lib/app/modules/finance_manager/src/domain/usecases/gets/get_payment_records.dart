import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';
import '../../entities/account.dart';
import '../../entities/payment_record.dart';

abstract interface class GetPaymentRecords {
  AsyncResult<List<PaymentRecord>, Fail> call({
    required int month,
    required int year,
    required Account account,
  });
}
