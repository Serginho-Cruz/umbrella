import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/installment_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/installment.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

class InstallmentRepositoryImpl implements InstallmentRepository {
  @override
  AsyncResult<int, Fail> create(Installment installment) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> delete(Installment installment) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  AsyncResult<List<Installment>, Fail> getAllOf(
      {required int month, required int year, required Account account}) {
    // TODO: implement getAllOf
    throw UnimplementedError();
  }

  @override
  AsyncResult<double, Fail> getInstallmentParcelsInRange(
      {required Date inferiorLimit,
      required Date upperLimit,
      required Account account}) {
    // TODO: implement getInstallmentParcelsInRange
    throw UnimplementedError();
  }

  @override
  AsyncResult<List<Installment>, Fail> searchByPaiyable(Paiyable paiyable) {
    // TODO: implement searchByPaiyable
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> update(
      Installment oldInstallment, Installment newInstallment) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
