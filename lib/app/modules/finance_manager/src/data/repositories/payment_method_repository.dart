import 'package:result_dart/result_dart.dart';
import '../../domain/entities/payment_method.dart';
import '../../errors/errors.dart';

import '../../domain/entities/paiyable.dart';

abstract interface class PaymentMethodRepository {
  AsyncResult<Unit, Fail> registerPayment({
    required Paiyable paiyable,
    required double value,
    required PaymentMethod method,
  });
  AsyncResult<Unit, Fail> updatePaymentRecord({
    required Paiyable paiyable,
    required double newValue,
    required PaymentMethod method,
  });
  AsyncResult<double, Fail> getValuePaidWithMethod(
    Paiyable paiyable,
    PaymentMethod method,
  );
  AsyncResult<Unit, Fail> removeValueFromMethod({
    required Paiyable paiyable,
    required PaymentMethod method,
    required double value,
  });
  AsyncResult<Unit, Fail> deletePaymentRecord(Paiyable paiyable);
}
