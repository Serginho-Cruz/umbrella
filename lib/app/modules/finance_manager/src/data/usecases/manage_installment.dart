import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/installment.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/manage_installment.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

class ManageInstallmentImpl implements ManageInstallment {
  @override
  AsyncResult<int, Fail> register(Installment installment) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> update({
    required Installment newInstallment,
    required Installment oldInstallment,
    bool isToShareValue = true,
    int parcelNumber = 0,
  }) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  AsyncResult<List<Installment>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) {
    // TODO: implement getAllOf
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> changeCardOfInstallment({
    required CreditCard newCard,
    required Installment installment,
  }) {
    // TODO: implement changeCardOfInstallment
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> changeParcelValue({
    required int parcelNumber,
    required double newValue,
    required Installment installment,
  }) {
    // TODO: implement changeParcelValue
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> cancel(Installment installment) {
    // TODO: implement cancel
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> deleteParcelAndNextOnesOfInstallment({
    required int parcelNumber,
    required Installment installment,
  }) {
    // TODO: implement deleteParcelAndNextOnesOfInstallment
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> deleteParcelOfInstallment({
    required int parcelNumber,
    required Installment installment,
  }) {
    // TODO: implement deleteParcelOfInstallment
    throw UnimplementedError();
  }
}
