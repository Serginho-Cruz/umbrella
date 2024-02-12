import 'package:result_dart/result_dart.dart';
import '../../repositories/iexpense_type_repository.dart';
import '../../../domain/entities/expense_type.dart';
import '../../../domain/usecases/gets/iget_expense_types.dart';
import '../../../errors/errors.dart';

class GetExpenseTypes implements IGetExpenseTypes {
  final IExpenseTypeRepository repository;

  GetExpenseTypes(this.repository);
  @override
  Future<Result<List<ExpenseType>, Fail>> call() => repository.getAll();
}
