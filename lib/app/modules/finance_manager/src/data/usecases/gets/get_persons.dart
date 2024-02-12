import 'package:result_dart/result_dart.dart';
import '../../repositories/iexpense_repository.dart';
import '../../../domain/usecases/gets/iget_persons.dart';
import '../../../errors/errors.dart';

import '../../repositories/iincome_repository.dart';

class GetPersons implements IGetPersons {
  final IIncomeRepository incomeRepository;
  final IExpenseRepository expenseRepository;

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
