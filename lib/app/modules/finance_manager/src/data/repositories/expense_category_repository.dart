import 'package:result_dart/result_dart.dart';

import '../../domain/entities/category.dart';
import '../../errors/errors.dart';

abstract interface class ExpenseCategoryRepository {
  AsyncResult<List<Category>, Fail> getAll();
}
