import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_type_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/gets/get_expense_types.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_type.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/gets/iget_expense_types.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../../utils/factorys/expense_type_factory.dart';
import '../../repositories/expense_type_repositor_mock.dart';

void main() {
  late IExpenseTypeRepository repository;
  late IGetExpenseTypes usecase;
  late List<ExpenseType> types = [];

  setUp(() {
    repository = ExpenseTypeRepositoryMock();
    usecase = GetExpenseTypes(repository);
    types.clear();
    types.addAll(List.generate(8, (_) => ExpenseTypeFactory.generate()));
  });

  group("Get Expense Types Usecase is Working", () {
    test("answer the same list returned by repository when no error happens",
        () async {
      when(() => repository.getAll()).thenAnswer((_) async => Success(types));

      final result = await usecase();

      verify(() => repository.getAll()).called(1);

      expect(result.isSuccess(), isTrue);
      expect(result.fold((s) => s, (f) => f), isA<List<ExpenseType>>());
      expect(result.fold((s) => s, (f) => f), equals(types));
    });
    test("answer the same error returned by repository when errors happens",
        () async {
      final fail = Fail("");
      when(() => repository.getAll()).thenAnswer((_) async => Failure(fail));

      final result = await usecase();

      verify(() => repository.getAll()).called(1);

      expect(result.isError(), isTrue);
      expect(result.fold((s) => s, (f) => f), isA<Fail>());
      expect(result.fold((s) => s, (f) => f), equals(fail));
    });
  });
}
