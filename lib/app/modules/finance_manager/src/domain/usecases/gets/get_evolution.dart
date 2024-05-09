import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

import '../../../errors/errors.dart';
import '../../entities/account.dart';

abstract interface class GetEvolutionOf {
  AsyncResult<Map<int, double>, Fail> spentMoneyBetween({
    required Date initialDate,
    required Date finalDate,
    required Account account,
  });
  AsyncResult<Map<int, double>, Fail> receivedMoneyBetween({
    required Date initialDate,
    required Date finalDate,
    required Account account,
  });
}
