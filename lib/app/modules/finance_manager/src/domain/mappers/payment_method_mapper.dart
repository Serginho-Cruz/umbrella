import '../entities/payment_method.dart';

abstract class PaymentMethodMapper {
  static Map<String, dynamic> toMap(PaymentMethod paymentMethod) {
    return <String, dynamic>{
      'method_id': paymentMethod.id,
      'method_name': paymentMethod.name,
    };
  }

  static PaymentMethod fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['method_id'] as int,
      name: map['method_name'] as String,
    );
  }
}
