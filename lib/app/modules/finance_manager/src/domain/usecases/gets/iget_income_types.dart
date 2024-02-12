import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';
import '../../entities/income_type.dart';

abstract class IGetIncomeTypes {
  Future<Result<List<IncomeType>, Fail>> call();
}
