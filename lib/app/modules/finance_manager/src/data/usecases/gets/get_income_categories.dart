import 'package:result_dart/result_dart.dart';
import '../../../domain/entities/category.dart';
import '../../repositories/income_category_repository.dart';
import '../../../domain/usecases/gets/get_income_categories.dart';
import '../../../errors/errors.dart';

class RemoteGetIncomeCategories implements GetIncomeCategories {
  final IncomeCategoryRepository repository;

  RemoteGetIncomeCategories(this.repository);

  @override
  AsyncResult<List<Category>, Fail> call() => repository.getAll();
}
