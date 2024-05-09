import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';
import '../../entities/expense_type.dart';

abstract interface class GetExpenseTypes {
  AsyncResult<List<ExpenseType>, Fail> call();
}
