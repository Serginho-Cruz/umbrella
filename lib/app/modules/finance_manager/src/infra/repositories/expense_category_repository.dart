import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/expense_category_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/expense_category_datasource.dart';

import '../../domain/entities/category.dart';

class ExpenseCategoryRepositoryImpl implements ExpenseCategoryRepository {
  final ExpenseCategoryDatasource _datasource;

  ExpenseCategoryRepositoryImpl(this._datasource);

  @override
  AsyncResult<List<Category>, Fail> getAll() async {
    try {
      var categories = await _datasource.getAll();
      return Success(categories);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }
}
