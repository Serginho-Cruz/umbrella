import '../../domain/entities/category.dart';

abstract interface class ExpenseCategoryDatasource {
  Future<List<Category>> getAll();
}
