import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_parcel_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import '../repositories/iinstallment_repository.dart';
import '../../domain/entities/installment.dart';
import '../../domain/usecases/imanage_installment.dart';
import '../../errors/errors.dart';

class ManageInstallment implements IManageInstallment {
  final IInstallmentRepository installmentRepository;
  final IExpenseRepository expenseRepository;
  final IExpenseParcelRepository expenseParcelRepository;

  ManageInstallment({
    required this.installmentRepository,
    required this.expenseRepository,
    required this.expenseParcelRepository,
  });

  @override
  Future<Result<void, Fail>> changeCardOfInstallment(
      {required CreditCard newCard, required Installment installment}) {
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
  Future<Result<void, Fail>> delete(Installment installment) {
    // TODO: implement delete
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
  Future<Result<List<Installment>, Fail>> getAllOf(DateTime month) {
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
