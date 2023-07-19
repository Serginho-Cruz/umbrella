import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/ipayment_method_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/gets/iget_payment_methods.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

class GetPaymentMethods implements IGetPaymentMethods {
  final IPaymentMethodRepository repository;

  GetPaymentMethods(this.repository);
  @override
  Future<Result<List<PaymentMethod>, Fail>> call() => repository.getAll();
}
