import 'package:result_dart/result_dart.dart';
import '../../repositories/ipayment_method_repository.dart';
import '../../../domain/entities/payment_method.dart';
import '../../../domain/usecases/gets/iget_payment_methods.dart';
import '../../../errors/errors.dart';

class GetPaymentMethods implements IGetPaymentMethods {
  final IPaymentMethodRepository repository;

  GetPaymentMethods(this.repository);
  @override
  Future<Result<List<PaymentMethod>, Fail>> call() => repository.getAll();
}
