import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

import '../../domain/entities/installment.dart';
import '../../errors/errors.dart';

abstract class IInstallmentRepository {
  Future<Result<int, Fail>> create(Installment installment);
  Future<Result<void, Fail>> update(Installment newInstallment);
  Future<Result<List<Installment>, Fail>> getAllOf({
    required int month,
    required int year,
  });
  Future<Result<double, Fail>> getSumOfInstallmentParcelsInRange({
    required Date inferiorLimit,
    required Date upperLimit,
  });
  Future<Result<void, Fail>> delete(Installment installment);
}
