import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';
import '../../entities/transaction.dart';

abstract class IGetTransactionsOf {
  Future<Result<List<Transaction>, Fail>> call(DateTime month);
}
