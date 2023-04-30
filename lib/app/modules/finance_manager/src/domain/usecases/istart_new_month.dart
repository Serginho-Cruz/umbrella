import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';

abstract class IStartNewMonth {
  Future<Result<void, Fail>> call(int todayDay);
}
