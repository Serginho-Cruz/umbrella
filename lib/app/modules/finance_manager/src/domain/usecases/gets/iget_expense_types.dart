import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';
import '../../entities/expense_type.dart';

abstract class IGetExpenseTypes {
  Future<Result<List<ExpenseType>, Fail>> call();
}
