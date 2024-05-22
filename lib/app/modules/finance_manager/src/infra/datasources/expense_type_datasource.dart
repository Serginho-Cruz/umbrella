import '../../domain/entities/expense_type.dart';

abstract interface class ExpenseTypeDatasource {
  Future<List<ExpenseType>> getAll();
}
