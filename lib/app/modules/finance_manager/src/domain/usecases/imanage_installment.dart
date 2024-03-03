import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/credit_card.dart';
import '../entities/installment.dart';

abstract class IManageInstallment {
  Future<Result<void, Fail>> register(Installment installment);
  Future<Result<void, Fail>> update({
    required Installment newInstallment,
    required Installment oldInstallment,
    bool isToShareValue = true,
    int parcelNumber = 0,
  });
  Future<Result<void, Fail>> changeParcelValue({
    required int parcelNumber,
    required double newValue,
    required Installment installment,
  });
  Future<Result<void, Fail>> changeCardOfInstallment({
    required CreditCard newCard,
    required Installment installment,
  });
  Future<Result<List<Installment>, Fail>> getAllOf({
    required int month,
    required int year,
  });
  Future<Result<void, Fail>> deleteParcelOfInstallment({
    required int parcelNumber,
    required Installment installment,
  });
  Future<Result<void, Fail>> deleteParcelAndNextOnesOfInstallment({
    required int parcelNumber,
    required Installment installment,
  });
  Future<Result<void, Fail>> cancel(Installment installment);
}
