import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iincome_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/gets/get_persons.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/gets/iget_persons.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../repositories/expense_repository_mock.dart';
import '../../repositories/income_repository_mock.dart';

void main() {
  late IGetPersons usecase;
  late IExpenseRepository expenseRepository;
  late IIncomeRepository incomeRepository;

  setUp(() {
    expenseRepository = ExpenseRepositoryMock();
    incomeRepository = IncomeRepositoryMock();
    usecase = GetPersons(
      expenseRepository: expenseRepository,
      incomeRepository: incomeRepository,
    );
  });

  group("Get Persons Usecase is Working", () {
    setUp(() {
      when(() => expenseRepository.getPersonsNames()).thenAnswer((_) async =>
          const Success(
              ['Rose', 'Joe', 'Jhonny', 'Barbie', 'Raquel', 'Michael']));
      when(() => incomeRepository.getPersonsNames()).thenAnswer((_) async =>
          const Success(
              ['Margaret', 'Simon', 'Michael', 'Raquel', 'Suzan', 'Joe']));
    });
    test("returns a list of persons names when no error happens", () async {
      final result = await usecase();

      expect(
        result.isSuccess(),
        isTrue,
        reason: 'A list must be returned because repositories returned values',
      );
      expect(
        result.fold((s) => s, (f) => f),
        isNotEmpty,
        reason: 'Repositories returned names, so the list must not be empty',
      );

      verify(() => expenseRepository.getPersonsNames());
      verify(() => incomeRepository.getPersonsNames());
    });
    test("returns a fail when an error happens", () async {
      when(() => expenseRepository.getPersonsNames())
          .thenAnswer((_) async => Failure(Fail("")));

      var result = await usecase();

      expect(
        result.isError(),
        isTrue,
        reason:
            'Must return an error because expense repository returned an error',
      );

      when(() => expenseRepository.getPersonsNames()).thenAnswer((_) async =>
          const Success(
              ['Rose', 'Joe', 'Jhonny', 'Barbie', 'Raquel', 'Michael']));
      when(() => incomeRepository.getPersonsNames())
          .thenAnswer((_) async => Failure(Fail("")));

      result = await usecase();

      expect(
        result.isError(),
        isTrue,
        reason:
            'Must return an error because income repository returned an error',
      );

      verify(() => expenseRepository.getPersonsNames());
      verify(() => incomeRepository.getPersonsNames());
    });
    test("the list returned must not contain repeated names", () async {
      final result = await usecase();

      final list = result.getOrElse((f) => []);
      final copyList = [...list];
      for (var string in list) {
        copyList.remove(string);
        expect(
          copyList.contains(string),
          isFalse,
          reason: 'The value $string was duplicated in the list',
        );
      }
    });
  });
}
