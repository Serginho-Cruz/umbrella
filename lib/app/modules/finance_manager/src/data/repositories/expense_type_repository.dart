import 'package:result_dart/result_dart.dart';

import '../../domain/entities/expense_type.dart';
import '../../errors/errors.dart';

abstract interface class ExpenseTypeRepository {
  AsyncResult<List<ExpenseType>, Fail> getAll();
}
