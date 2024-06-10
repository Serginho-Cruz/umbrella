import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';
import '../../entities/category.dart';

abstract interface class GetIncomeCategories {
  AsyncResult<List<Category>, Fail> call();
}
