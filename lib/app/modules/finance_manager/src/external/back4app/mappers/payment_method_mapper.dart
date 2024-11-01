import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../domain/entities/payment_method.dart';
import '../parse_objects.dart';

sealed class PaymentMethodMapper {
  static PaymentMethodObject toParse(PaymentMethod method) {
    var object = PaymentMethodObject();

    object.objectId = method.id;
    object.set('name', method.name);
    object.set('iconName', method.icon);

    return object;
  }

  static PaymentMethod fromParse(ParseObject object) {
    String id = object.objectId!;

    String name = object.get('name');
    String icon = object.get('iconName');

    return PaymentMethod(id: id, name: name, icon: icon);
  }
}
