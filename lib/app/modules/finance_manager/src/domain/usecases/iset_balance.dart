import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

abstract class ISetBalance {
  Future<Result<void, Fail>> initial(double newBalance);
  Future<Result<void, Fail>> actual(double newBalance);
}
