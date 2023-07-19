import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

abstract class IPaymentMethodRepository {
  Future<Result<List<PaymentMethod>, Fail>> getAll();
}
