import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iincome_type_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/gets/get_income_types.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_type.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/gets/iget_income_types.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../../utils/factorys/income_type_factory.dart';
import '../../repositories/income_type_repository_mock.dart';

void main() {
  late IIncomeTypeRepository repository;
  late IGetIncomeTypes usecase;
  late List<IncomeType> types = [];

  setUp(() {
    repository = IncomeTypeRepositoryMock();
    usecase = GetIncomeTypes(repository);
    types.clear();
    types.addAll(List.generate(8, (_) => IncomeTypeFactory.generate()));
  });
  group("Get Income Types Usecase is Working", () {
    test("answer the same list returned by repository when no error happens",
        () async {
      when(() => repository.getAll()).thenAnswer((_) async => Success(types));

      final result = await usecase();

      verify(() => repository.getAll()).called(1);

      expect(result.isSuccess(), isTrue);
      expect(result.fold((s) => s, (f) => f), isA<List<IncomeType>>());
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
