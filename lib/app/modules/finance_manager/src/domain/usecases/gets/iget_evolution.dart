import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';

abstract class IGetEvolutionOf {
  Future<Result<Map<int, double>, Fail>> spentMoneyBetween({
    required DateTime initialDay,
    required DateTime finalDay,
  });
  Future<Result<Map<int, double>, Fail>> receivedMoneyBetween({
    required DateTime initialDay,
    required DateTime finalDay,
  });
}
