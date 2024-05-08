import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/installment.dart';
import '../../errors/errors.dart';

abstract interface class InstallmentRepository {
  AsyncResult<int, Fail> create(Installment installment);
  AsyncResult<Unit, Fail> update(
    Installment oldInstallment,
    Installment newInstallment,
  );
  AsyncResult<List<Installment>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  });
  AsyncResult<double, Fail> getInstallmentParcelsInRange({
    required Date inferiorLimit,
    required Date upperLimit,
    required Account account,
  });
  AsyncResult<List<Installment>, Fail> searchByPaiyable(Paiyable paiyable);
  AsyncResult<Unit, Fail> delete(Installment installment);
}
