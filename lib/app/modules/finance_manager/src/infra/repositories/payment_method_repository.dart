import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/payment_method_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../datasources/payment_method_datasource.dart';

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  final PaymentMethodDatasource _datasource;

  PaymentMethodRepositoryImpl(this._datasource);

  @override
  AsyncResult<Unit, Fail> deletePaymentRecord(Paiyable paiyable) {
    // TODO: implement deletePaymentRecord
    throw UnimplementedError();
  }

  @override
  AsyncResult<double, Fail> getValuePaidWithMethod(
    Paiyable paiyable,
    PaymentMethod method,
  ) async {
    try {
      double value = await _datasource.getValuePaidWithMethod(paiyable, method);

      return Success(value);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return const Failure(GenericError());
    }
  }

  @override
  AsyncResult<Unit, Fail> registerPayment({
    required Paiyable paiyable,
    required double value,
    required PaymentMethod method,
  }) async {
    try {
      await _datasource.registerPayment(
        paiyable: paiyable,
        value: value,
        method: method,
      );

      return const Success(unit);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return const Failure(GenericError());
    }
  }

  @override
  AsyncResult<Unit, Fail> removeValueFromMethod({
    required Paiyable paiyable,
    required PaymentMethod method,
    required double value,
  }) async {
    try {
      await _datasource.removeValueFromPaymentRecord(
        paiyable: paiyable,
        value: value,
        method: method,
      );

      return const Success(unit);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return const Failure(GenericError());
    }
  }

  @override
  AsyncResult<Unit, Fail> updatePaymentRecord({
    required Paiyable paiyable,
    required double newValue,
    required PaymentMethod method,
  }) async {
    try {
      await _datasource.updatePaymentRecord(
        paiyable: paiyable,
        newValue: newValue,
        method: method,
      );

      return const Success(unit);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return const Failure(GenericError());
    }
  }
}
