import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

import '../../errors/errors.dart';

abstract class IStartNewMonth {
  Future<Result<void, Fail>> call(Date day);
}
