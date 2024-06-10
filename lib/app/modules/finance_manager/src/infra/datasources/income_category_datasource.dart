import '../../domain/entities/category.dart';

abstract interface class IncomeCategoryDatasource {
  Future<List<Category>> getAll();
}
