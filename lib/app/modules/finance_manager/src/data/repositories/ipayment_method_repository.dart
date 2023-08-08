import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../domain/entities/expense_parcel.dart';
import '../../domain/entities/paiyable.dart';

abstract class IPaymentMethodRepository {
  Future<Result<void, Fail>> payWithMethod({
    required Paiyable paiyable,
    required double value,
    required PaymentMethod method,
  });
  Future<Result<void, Fail>> payWithCreditMethod({
    required ExpenseParcel parcel,
    required double value,
  });
  Future<Result<List<PaymentMethod>, Fail>> getAll();
  Future<Result<double, Fail>> getValuePaidWithCredit(ExpenseParcel parcel);
  Future<Result<void, Fail>> removeValueFromNoCreditMethods({
    required ExpenseParcel parcel,
    required double value,
  });
  Future<Result<void, Fail>> removeValueFromCreditMethod({
    required ExpenseParcel parcel,
    required double value,
  });
  Future<Result<void, Fail>> removeValueFromCreditMethodForAll(
    Map<ExpenseParcel, double> valueParcel,
  );
}
