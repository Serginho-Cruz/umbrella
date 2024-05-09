import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';
import '../../entities/account.dart';

abstract interface class GetBalance {
  AsyncResult<double, Fail> initialOf({
    required int month,
    required int year,
    required Account account,
  });
  AsyncResult<double, Fail> expectedOf({
    required int month,
    required int year,
    required Account account,
  });
  AsyncResult<double, Fail> finalOf({
    required int month,
    required int year,
    required Account account,
  });
}
