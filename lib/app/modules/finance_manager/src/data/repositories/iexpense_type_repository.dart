import 'package:result_dart/result_dart.dart';

import '../../domain/entities/expense_type.dart';
import '../../errors/errors.dart';

abstract class IExpenseTypeRepository {
  Future<Result<List<ExpenseType>, Fail>> getAll();
}
