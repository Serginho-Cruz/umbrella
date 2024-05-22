import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/income_type_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_type.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../datasources/income_type_datasource.dart';

class IncomeTypeRepositoryImpl implements IncomeTypeRepository {
  final IncomeTypeDatasource _datasource;

  IncomeTypeRepositoryImpl(this._datasource);

  @override
  AsyncResult<List<IncomeType>, Fail> getAll() async {
    try {
      var types = await _datasource.getAll();
      return Success(types);
    } on Fail catch (f) {
      return Failure(f);
    } catch (e) {
      return Failure(GenericError());
    }
  }
}
