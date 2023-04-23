import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/installment.dart';

abstract class IMaintainInstallment {
  Result<void, Fail> register(Installment installment);
  Result<void, Fail> update(Installment newInstallment);
  Result<void, Fail> reInstall({
    required Installment installment,
    required int newParcelsNumber,
  });
  Result<List<Installment>, Fail> getAll(int month);
  Result<void, Fail> delete(Installment installment);
}
