import '../../repositories/expense_repository.dart';
import '../../../domain/usecases/gets/get_persons.dart';

import '../../repositories/income_repository.dart';

class GetPersonsImpl implements GetPersons {
  final IncomeRepository incomeRepository;
  final ExpenseRepository expenseRepository;

  GetPersonsImpl({
    required this.incomeRepository,
    required this.expenseRepository,
  });

  @override
  Future<List<String>> call() async {
    var lists = await Future.wait([
      incomeRepository.getPersons(),
      expenseRepository.getPersons(),
    ]);

    List<String> names = [];

    for (var list in lists) {
      names.addAll(list.getOrDefault([]));
    }

    var noDuplicates = names.toSet().toList();

    return noDuplicates;
  }
}
