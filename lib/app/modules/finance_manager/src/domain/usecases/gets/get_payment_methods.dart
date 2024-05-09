import '../../entities/payment_method.dart';

abstract interface class GetPaymentMethods {
  List<PaymentMethod> call();
}
