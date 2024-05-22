import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/payment_method_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  @override
  AsyncResult<Unit, Fail> deletePaymentRecord(Paiyable paiyable) {
    // TODO: implement deletePaymentRecord
    throw UnimplementedError();
  }

  @override
  AsyncResult<double, Fail> getValuePaidWithMethod(
    Paiyable paiyable,
    PaymentMethod method,
  ) {
    // TODO: implement getValuePaidWithMethod
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> registerPayment({
    required Paiyable paiyable,
    required double value,
    required PaymentMethod method,
  }) {
    // TODO: implement registerPayment
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> removeValueFromMethod({
    required Paiyable paiyable,
    required PaymentMethod method,
    required double value,
  }) {
    // TODO: implement removeValueFromMethod
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> updatePaymentRecord({
    required Paiyable paiyable,
    required double newValue,
    required PaymentMethod method,
  }) {
    // TODO: implement updatePaymentRecord
    throw UnimplementedError();
  }
}
