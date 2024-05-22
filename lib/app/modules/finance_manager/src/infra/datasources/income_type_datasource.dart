import '../../domain/entities/income_type.dart';

abstract interface class IncomeTypeDatasource {
  Future<List<IncomeType>> getAll();
}
