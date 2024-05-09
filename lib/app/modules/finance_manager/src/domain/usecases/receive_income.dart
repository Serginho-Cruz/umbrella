import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/account.dart';
import '../entities/income.dart';

abstract interface class ReceiveIncome {
  AsyncResult<Unit, Fail> call({
    required Income income,
    required double value,
    required Account account,
  });
  AsyncResult<Unit, Fail> advance({
    required Income income,
    required double valueToAdvance,
    required Account account,
  });
}
