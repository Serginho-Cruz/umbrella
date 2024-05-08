import 'package:result_dart/result_dart.dart';
import '../../repositories/income_type_repository.dart';
import '../../../domain/entities/income_type.dart';
import '../../../domain/usecases/gets/iget_income_types.dart';
import '../../../errors/errors.dart';

class GetIncomeTypes implements IGetIncomeTypes {
  final IncomeTypeRepository repository;

  GetIncomeTypes(this.repository);

  @override
  Future<Result<List<IncomeType>, Fail>> call() => repository.getAll();
}
