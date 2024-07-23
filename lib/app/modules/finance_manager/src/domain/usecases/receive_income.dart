import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment.dart';
import '../../errors/errors.dart';

abstract interface class ReceiveIncome {
  AsyncResult<Unit, Fail> call(Payment<Income> income);
}
