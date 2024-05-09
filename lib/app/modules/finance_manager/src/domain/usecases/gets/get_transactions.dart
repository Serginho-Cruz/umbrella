import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';
import '../../entities/account.dart';
import '../../entities/transaction.dart';

abstract interface class GetTransactionsOf {
  AsyncResult<List<Transaction>, Fail> call({
    required int month,
    required int year,
    required Account account,
  });
}
