import 'package:result_dart/result_dart.dart';
import '../../repositories/income_type_repository.dart';
import '../../../domain/entities/income_type.dart';
import '../../../domain/usecases/gets/get_income_types.dart';
import '../../../errors/errors.dart';

class RemoteGetIncomeTypes implements GetIncomeTypes {
  final IncomeTypeRepository repository;

  RemoteGetIncomeTypes(this.repository);

  @override
  AsyncResult<List<IncomeType>, Fail> call() => repository.getAll();
}
