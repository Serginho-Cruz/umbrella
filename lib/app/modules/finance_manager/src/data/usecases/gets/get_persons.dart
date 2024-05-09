import 'package:result_dart/result_dart.dart';
import '../../repositories/expense_repository.dart';
import '../../../domain/usecases/gets/get_persons.dart';
import '../../../errors/errors.dart';

import '../../repositories/income_repository.dart';

class LocalGetPersons implements GetPersons {
  final IncomeRepository incomeRepository;
  final ExpenseRepository expenseRepository;

  LocalGetPersons({
    required this.incomeRepository,
    required this.expenseRepository,
  });
  @override
  AsyncResult<List<String>, Fail> call() async {
    return ["Maria", "Rodrigo", "César", "Julia"].toSuccess();
  }
}
