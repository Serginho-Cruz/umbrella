import '../../domain/entities/paiyable.dart';
import '../../domain/entities/payment_method.dart';

abstract interface class PaymentMethodDatasource {
  Future<void> registerPayment({
    required Paiyable paiyable,
    required double value,
    required PaymentMethod method,
  });
  Future<void> updatePaymentRecord({
    required Paiyable paiyable,
    required double newValue,
    required PaymentMethod method,
  });
  Future<double> getValuePaidWithMethod(
    Paiyable paiyable,
    PaymentMethod method,
  );
  Future<void> removeValueFromPaymentRecord({
    required Paiyable paiyable,
    required PaymentMethod method,
    required double value,
  });
  Future<void> deletePaymentRecord(Paiyable paiyable);
}
