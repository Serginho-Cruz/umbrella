import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iincome_type_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_type.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/gets/iget_income_types.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

class GetIncomeTypes implements IGetIncomeTypes {
  final IIncomeTypeRepository repository;

  GetIncomeTypes(this.repository);

  @override
  Future<Result<List<IncomeType>, Fail>> call() => repository.getAll();
}
