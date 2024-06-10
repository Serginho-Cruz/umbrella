import 'package:result_dart/result_dart.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/usecases/gets/get_expense_categories.dart';
import '../../../errors/errors.dart';
import '../../repositories/expense_category_repository.dart';

class RemoteGetExpenseCategories implements GetExpenseCategories {
  final ExpenseCategoryRepository repository;

  RemoteGetExpenseCategories(this.repository);
  @override
  AsyncResult<List<Category>, Fail> call() => repository.getAll();
}
