import 'package:result_dart/result_dart.dart';
import '../../domain/entities/payment_method.dart';
import '../../errors/errors.dart';

import '../../domain/entities/paiyable.dart';

abstract class IPaymentMethodRepository {
  Future<Result<void, Fail>> payWithMethod({
    required Paiyable paiyable,
    required double value,
    required PaymentMethod method,
  });
  Future<Result<void, Fail>> payWithCreditMethod({
    required Paiyable paiyable,
    required double value,
  });
  Future<Result<double, Fail>> getValuePaidWithCredit(Paiyable paiyable);
  Future<Result<void, Fail>> removeValueFromNoCreditMethods({
    required Paiyable paiyable,
    required double value,
  });
  Future<Result<void, Fail>> removeValueFromCreditMethod({
    required Paiyable paiyable,
    required double value,
  });
  Future<Result<void, Fail>> removeValueFromCreditMethodForAll(
    Map<Paiyable, double> paiyableValueMap,
  );
}
