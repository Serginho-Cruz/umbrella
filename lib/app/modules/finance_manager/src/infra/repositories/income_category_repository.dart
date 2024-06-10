import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/income_category_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../domain/entities/category.dart';
import '../datasources/income_category_datasource.dart';

class IncomeCategoryRepositoryImpl implements IncomeCategoryRepository {
  final IncomeCategoryDatasource _datasource;

  IncomeCategoryRepositoryImpl(this._datasource);

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
