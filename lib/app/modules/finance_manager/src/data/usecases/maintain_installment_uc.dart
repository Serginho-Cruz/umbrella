import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_parcel_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';
import '../repositories/iinstallment_repository.dart';
import '../../domain/entities/installment.dart';
import '../../domain/usecases/imaintain_installment.dart';
import '../../errors/errors.dart';

class MaintainInstallment implements IMaintainInstallment {
  final IInstallmentRepository installmentRepository;
  final IExpenseRepository expenseRepository;
  final IExpenseParcelRepository expenseParcelRepository;

  MaintainInstallment({
    required this.installmentRepository,
    required this.expenseRepository,
    required this.expenseParcelRepository,
  });

  @override
  Future<Result<void, Fail>> register(Installment installment) async {
    var result = await installmentRepository.create(installment);

    if (result.isError()) {
      return result;
    }

    var createParcelsResult =
        await expenseParcelRepository.createParcelsOfInstallment(
      parcels: installment.parcels,
      installmentId: result.getOrThrow(),
    );

    return createParcelsResult;
  }

  @override
  Future<Result<void, Fail>> update(Installment newInstallment) async {
    var result = await installmentRepository.getById(newInstallment.id);

    if (result.isError()) {
      return result;
    }

    var oldInstallment = result.getOrThrow();

    if (oldInstallment.totalValue != newInstallment.totalValue) {
      for (var parcel in newInstallment.parcels) {
        var newValue = newInstallment.totalValue / newInstallment.parcelsNumber;

        parcel.parcelValue = newValue.roundToDecimal();
        parcel.remainingValue = parcel.parcelValue - parcel.paidValue;
      }
    }

    var updateInstall = await installmentRepository.update(newInstallment);
    if (updateInstall.isError()) {
      return updateInstall;
    }

    var updateParcelsResult =
        await expenseParcelRepository.updateParcels(newInstallment.parcels);

    return updateParcelsResult;
  }

  @override
  Future<Result<List<Installment>, Fail>> getAll(int month) =>
      installmentRepository.getAllOfMonth(month);

  @override
  Future<Result<void, Fail>> delete(Installment installment) async {
    var expensesDeleteResult = await expenseParcelRepository.deleteParcels(
      installment.parcels,
    );

    if (expensesDeleteResult.isError()) {
      return expensesDeleteResult;
    }

    var installmentDeleteResult = await installmentRepository.delete(
      installment,
    );

    if (installmentDeleteResult.isError()) {
      return installmentDeleteResult;
    }

    var expenseDeleteResult = await expenseRepository.delete(
      installment.expense,
    );

    return expenseDeleteResult;
  }
}
