import 'package:result_dart/result_dart.dart';

import '../../domain/entities/installment.dart';
import '../../errors/errors.dart';

abstract class IInstallmentRepository {
  Future<Result<void, Fail>> create(Installment installment);
  Future<Result<void, Fail>> update(Installment newInstallment);
  Future<Result<List<Installment>, Fail>> getAllOfMonth(int month);
  Future<Result<void, Fail>> delete(Installment installment);
}
