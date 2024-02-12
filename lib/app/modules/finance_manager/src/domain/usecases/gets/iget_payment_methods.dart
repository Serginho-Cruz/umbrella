import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';
import '../../entities/payment_method.dart';

abstract class IGetPaymentMethods {
  Future<Result<List<PaymentMethod>, Fail>> call();
}
