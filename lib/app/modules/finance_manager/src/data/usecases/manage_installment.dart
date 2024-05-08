import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/installment.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imanage_installment.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

class ManageInstallment implements IManageInstallment {
  @override
  Future<Result<void, Fail>> cancel(Installment installment) {
    // TODO: implement cancel
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> changeCardOfInstallment({
    required CreditCard newCard,
    required Installment installment,
  }) {
    // TODO: implement changeCardOfInstallment
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> changeParcelValue(
      {required int parcelNumber,
      required double newValue,
      required Installment installment}) {
    // TODO: implement changeParcelValue
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> deleteParcelAndNextOnesOfInstallment(
      {required int parcelNumber, required Installment installment}) {
    // TODO: implement deleteParcelAndNextOnesOfInstallment
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> deleteParcelOfInstallment(
      {required int parcelNumber, required Installment installment}) {
    // TODO: implement deleteParcelOfInstallment
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Installment>, Fail>> getAllOf(
      {required int month, required int year}) {
    // TODO: implement getAllOf
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> register(Installment installment) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> update(
      {required Installment newInstallment,
      required Installment oldInstallment,
      bool isToShareValue = true,
      int parcelNumber = 0}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
