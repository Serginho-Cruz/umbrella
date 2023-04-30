import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/installment.dart';

abstract class IMaintainInstallment {
  Future<Result<void, Fail>> register(Installment installment);
  Future<Result<void, Fail>> update(Installment newInstallment);
  Future<Result<void, Fail>> reInstall({
    required Installment installment,
    required int newParcelsNumber,
  });
  Future<Result<List<Installment>, Fail>> getAll(int month);
  Future<Result<void, Fail>> delete(Installment installment);
}
