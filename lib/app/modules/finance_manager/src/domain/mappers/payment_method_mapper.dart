import '../../external/schemas/payment_method_table.dart';
import '../entities/payment_method.dart';

abstract class PaymentMethodMapper {
  static Map<String, dynamic> toMap(PaymentMethod paymentMethod) {
    return <String, dynamic>{
      PaymentMethodTable.id: paymentMethod.id,
      PaymentMethodTable.name: paymentMethod.name,
      PaymentMethodTable.isCredit: paymentMethod.isCredit,
      PaymentMethodTable.icon: paymentMethod.icon,
    };
  }

  static PaymentMethod fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map[PaymentMethodTable.id] as int,
      name: map[PaymentMethodTable.name] as String,
      icon: map[PaymentMethodTable.icon] as String,
      isCredit: map[PaymentMethodTable.isCredit] as bool,
    );
  }
}
