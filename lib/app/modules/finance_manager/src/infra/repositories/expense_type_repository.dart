import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/expense_type_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_type.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/expense_type_datasource.dart';

class ExpenseTypeRepositoryImpl implements ExpenseTypeRepository {
  final ExpenseTypeDatasource _datasource;

  ExpenseTypeRepositoryImpl(this._datasource);

  @override
  Future<Result<List<ExpenseType>, Fail>> getAll() async {
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
