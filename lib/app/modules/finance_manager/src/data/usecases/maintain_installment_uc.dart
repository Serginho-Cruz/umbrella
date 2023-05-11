import 'package:result_dart/result_dart.dart';
import '../../domain/entities/installment.dart';
import '../../domain/usecases/imaintain_installment.dart';
import '../../errors/errors.dart';

class MaintainInstallment implements IMaintainInstallment {
  @override
  Future<Result<void, Fail>> register(Installment installment) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> update(Installment newInstallment) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Installment>, Fail>> getAll(int month) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> delete(Installment installment) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
