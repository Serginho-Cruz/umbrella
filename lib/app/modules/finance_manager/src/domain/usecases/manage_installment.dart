import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/account.dart';
import '../entities/credit_card.dart';
import '../entities/installment.dart';

abstract interface class ManageInstallment {
  AsyncResult<int, Fail> register(Installment installment);
  AsyncResult<Unit, Fail> update({
    required Installment newInstallment,
    required Installment oldInstallment,
    bool isToShareValue = true,
    int parcelNumber = 0,
  });
  AsyncResult<Unit, Fail> changeParcelValue({
    required int parcelNumber,
    required double newValue,
    required Installment installment,
  });
  AsyncResult<Unit, Fail> changeCardOfInstallment({
    required CreditCard newCard,
    required Installment installment,
  });
  AsyncResult<List<Installment>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  });
  AsyncResult<Unit, Fail> deleteParcelOfInstallment({
    required int parcelNumber,
    required Installment installment,
  });
  AsyncResult<Unit, Fail> deleteParcelAndNextOnesOfInstallment({
    required int parcelNumber,
    required Installment installment,
  });
  AsyncResult<Unit, Fail> cancel(Installment installment);
}
