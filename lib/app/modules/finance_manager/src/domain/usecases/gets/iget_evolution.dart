import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

import '../../../errors/errors.dart';

abstract class IGetEvolutionOf {
  Future<Result<Map<int, double>, Fail>> spentMoneyBetween({
    required Date initialDay,
    required Date finalDay,
  });
  Future<Result<Map<int, double>, Fail>> receivedMoneyBetween({
    required Date initialDay,
    required Date finalDay,
  });
}
