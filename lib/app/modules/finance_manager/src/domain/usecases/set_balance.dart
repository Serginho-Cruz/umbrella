import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

abstract interface class SetBalance {
  AsyncResult<Unit, Fail> initial({
    required Account account,
    required double newBalance,
  });
}
