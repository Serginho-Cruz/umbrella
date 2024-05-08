import 'package:result_dart/result_dart.dart';
import '../../repositories/expense_repository.dart';
import '../../../domain/usecases/gets/iget_persons.dart';
import '../../../errors/errors.dart';

import '../../repositories/income_repository.dart';

class GetPersons implements IGetPersons {
  final IncomeRepository incomeRepository;
  final ExpenseRepository expenseRepository;

  GetPersons({required this.incomeRepository, required this.expenseRepository});
  @override
  Future<Result<List<String>, Fail>> call() async {
    var personsFromExpenses = await expenseRepository.getPersonsNames();

    if (personsFromExpenses.isError()) {
      return personsFromExpenses;
    }
    var personsFromIncomes = await incomeRepository.getPersonsNames();

    if (personsFromIncomes.isError()) {
      return personsFromIncomes;
    }

    Set<String> persons = {
      ...personsFromExpenses.getOrDefault([]),
      ...personsFromIncomes.getOrDefault([])
    };

    return Success(persons.toList());
  }
}
