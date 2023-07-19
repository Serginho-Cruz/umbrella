import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_type_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_type.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/gets/iget_expense_types.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

class GetExpenseTypes implements IGetExpenseTypes {
  final IExpenseTypeRepository repository;

  GetExpenseTypes(this.repository);
  @override
  Future<Result<List<ExpenseType>, Fail>> call() => repository.getAll();
}
