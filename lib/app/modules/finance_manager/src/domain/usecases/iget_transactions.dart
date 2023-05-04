import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/transaction.dart';

abstract class IGetTransactions {
  Future<Result<List<Transaction>, Fail>> call(int month);
}
