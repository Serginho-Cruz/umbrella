import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/maintain_expense_uc.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imaintain_expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../domain/factorys/expense_factory.dart';
import '../../domain/factorys/expense_parcel_factory.dart';
import '../repositories/expense_repository_mock.dart';

void main() {
  final IExpenseRepository repository = ExpenseRepositoryMock();
  final IMaintainExpense usecase = MaintainExpenseUC(repository);

  late Expense expense;
  late ExpenseParcel parcel;

  setUp(() {
    expense = ExpenseFactory.generate();
    parcel = ExpenseParcelFactory.generate(expense: expense);

    registerFallbackValue(expense);
    registerFallbackValue(parcel);
  });

  group("Maintain Expense usecase is working fine", () {
    group("Create Method is working", () {
      test("Returns void on Success", () async {
        when(() => repository.create(expense))
            .thenAnswer((_) async => const Success(2));

        final result = await usecase.register(expense);

        expect(result.isSuccess(), isTrue);
        expect(result.fold((s) {}, (f) => f), isA<void>());
      });

      test("Returns Fail on Error", () async {
        when(() => repository.create(expense))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.register(expense);

        expect(result.isError(), isTrue);
      });
    });
    group("Update Method is working", () {
      group("Update only parcel when update expense is false", () {
        test("Update the parcel when no errors occur", () async {
          when(() => repository.updateParcel(parcel))
              .thenAnswer((_) async => const Success(2));
          when(() => repository.updateExpense(any()))
              .thenAnswer((_) async => const Success(2));

          final result = await usecase.update(newParcel: parcel);

          verify(() => repository.updateParcel(parcel)).called(1);
          verifyNever(() => repository.updateExpense(any()));

          expect(result.isSuccess(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<void>());
        });
        test("Returns a Fail when some error occur", () async {
          when(() => repository.updateParcel(parcel))
              .thenAnswer((_) async => Failure(Fail("")));
          when(() => repository.updateExpense(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.update(newParcel: parcel);

          verify(() => repository.updateParcel(parcel)).called(1);
          verifyNever(() => repository.updateExpense(any()));

          expect(result.isError(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<Fail>());
        });
      });

      group("Update parcel and expense when update expense is true", () {
        test("Update parcel and expense when no errors occur", () async {
          when(() => repository.updateParcel(parcel))
              .thenAnswer((_) async => const Success(2));

          when(() => repository.updateExpense(expense))
              .thenAnswer((_) async => const Success(2));

          final result = await usecase.update(
            newParcel: parcel,
            updateExpense: true,
          );

          verify(() => repository.updateParcel(parcel)).called(1);
          verify(() => repository.updateExpense(expense)).called(1);

          expect(result.isSuccess(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<void>());
        });
        test("Returns an error when occur an error updating parcel", () async {
          when(() => repository.updateParcel(parcel))
              .thenAnswer((_) async => Failure(Fail("")));

          when(() => repository.updateExpense(any()))
              .thenAnswer((_) async => const Success(2));

          final result = await usecase.update(
            newParcel: parcel,
            updateExpense: true,
          );

          verify(() => repository.updateParcel(parcel)).called(1);
          verifyNever(() => repository.updateExpense(any()));

          expect(result.isError(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<Fail>());
        });
        test("Returns an error when occur an error updating expense", () async {
          when(() => repository.updateParcel(parcel))
              .thenAnswer((_) async => const Success(2));

          when(() => repository.updateExpense(expense))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.update(
            newParcel: parcel,
            updateExpense: true,
          );

          verify(() => repository.updateParcel(parcel)).called(1);
          verify(() => repository.updateExpense(expense)).called(1);

          expect(result.isError(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<Fail>());
        });
      });
    });
    group("Get All Method is working", () {
      test("Returns a List of Expense Parcels on Success", () async {
        when(() => repository.getAll(any())).thenAnswer(
            (_) async => Success(ExpenseParcelFactory.generateList()));

        final result = await usecase.getAll(2);

        verify(() => repository.getAll(any())).called(1);
        expect(result.isSuccess(), isTrue);
        expect(result.fold((s) => s, (f) => f), isA<List<ExpenseParcel>>());
      });

      test("Returns Fail on Error", () async {
        when(() => repository.getAll(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.getAll(2);

        verify(() => repository.getAll(any())).called(1);
        expect(result.isError(), isTrue);
        expect(result.fold((s) => s, (f) => f), isA<Fail>());
      });
    });
    group("Delete Method is working", () {
      group("Delete only parcel when delete expense parameter is false", () {
        test("Delete Parcel when no errors occur", () async {
          when(() => repository.deleteParcel(parcel))
              .thenAnswer((_) async => const Success(2));
          when(() => repository.deleteExpense(expense))
              .thenAnswer((_) async => const Success(2));

          final result = await usecase.delete(parcel: parcel);

          verifyNever(() => repository.deleteExpense(any()));
          verify(() => repository.deleteParcel(parcel)).called(1);
          expect(result.isSuccess(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<void>());
        });

        test("Returns a Fail when some error occur", () async {
          when(() => repository.deleteParcel(parcel))
              .thenAnswer((_) async => Failure(Fail("")));
          when(() => repository.deleteExpense(expense))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.delete(parcel: parcel);
          verifyNever(() => repository.deleteExpense(any()));
          verify(() => repository.deleteParcel(parcel)).called(1);
          expect(result.isError(), isTrue);
        });
      });
      group("Delete the parcel and expense when parameter is true", () {
        test("Delete Parcel and expense when no errors occur", () async {
          when(() => repository.deleteParcel(parcel))
              .thenAnswer((_) async => const Success(2));
          when(() => repository.deleteExpense(expense))
              .thenAnswer((_) async => const Success(2));

          final result = await usecase.delete(
            parcel: parcel,
            deleteExpense: true,
          );

          verify(() => repository.deleteExpense(expense)).called(1);
          verify(() => repository.deleteParcel(parcel)).called(1);

          expect(result.isSuccess(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<void>());
        });

        test("Returns a Fail when occur an error deleting parcel", () async {
          when(() => repository.deleteParcel(parcel))
              .thenAnswer((_) async => Failure(Fail("")));
          when(() => repository.deleteExpense(expense))
              .thenAnswer((_) async => const Success(2));

          final result = await usecase.delete(
            parcel: parcel,
            deleteExpense: true,
          );

          verify(() => repository.deleteParcel(parcel)).called(1);
          verifyNever(() => repository.deleteExpense(any()));

          expect(result.isError(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<Fail>());
        });
        test("Returns a Fail when occur an error deleting expense", () async {
          when(() => repository.deleteParcel(parcel))
              .thenAnswer((_) async => const Success(2));
          when(() => repository.deleteExpense(expense))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.delete(
            parcel: parcel,
            deleteExpense: true,
          );

          verify(() => repository.deleteParcel(parcel)).called(1);
          verify(() => repository.deleteExpense(expense)).called(1);

          expect(result.isError(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<Fail>());
        });
      });
    });
  });
}
