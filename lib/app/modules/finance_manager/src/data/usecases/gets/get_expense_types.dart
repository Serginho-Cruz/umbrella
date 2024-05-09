import 'package:result_dart/result_dart.dart';
import '../../repositories/expense_type_repository.dart';
import '../../../domain/entities/expense_type.dart';
import '../../../domain/usecases/gets/get_expense_types.dart';
import '../../../errors/errors.dart';

class RemoteGetExpenseTypes implements GetExpenseTypes {
  final ExpenseTypeRepository repository;

  RemoteGetExpenseTypes(this.repository);
  @override
  AsyncResult<List<ExpenseType>, Fail> call() => repository.getAll();
}
