import 'package:result_dart/result_dart.dart';

import '../../domain/entities/income_type.dart';
import '../../errors/errors.dart';

abstract class IIncomeTypeRepository {
  Future<Result<List<IncomeType>, Fail>> getAll();
}
