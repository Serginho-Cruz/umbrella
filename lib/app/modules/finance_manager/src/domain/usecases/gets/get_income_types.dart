import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';
import '../../entities/income_type.dart';

abstract interface class GetIncomeTypes {
  AsyncResult<List<IncomeType>, Fail> call();
}
