import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iincome_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/maintain_income_uc.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_type.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imaintain_income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import '../repositories/income_repository_mock.dart';

void main() {
  late IIncomeRepository repository;
  late IMaintainIncome usecase;
  late Income income;
  late IncomeParcel parcel;

  setUp(() {
    repository = IncomeRepositoryMock();
    usecase = MaintainIncomeUC(repository);
    income = Income(
      id: 1,
      name: "Payment",
      value: 2500.00,
      paymentDate: DateTime.now(),
      frequency: Frequency.monthly,
      type: IncomeType(
        id: 1,
        icon: "payment__icon",
        name: "Payment",
      ),
    );
    parcel = IncomeParcel(
      income: income,
      id: 2,
      paidValue: 200.00,
      remainingValue: 300.00,
      paymentDate: DateTime.now(),
      parcelValue: 500.00,
    );

    registerFallbackValue(parcel);
    registerFallbackValue(income);
  });

  group("Maintain Income usecase is working fine", () {
    group("Register Method is working", () {
      test("Returns void when no erros occur", () async {
        when(() => repository.create(any()))
            .thenAnswer((_) async => const Success(2));

        final result = await usecase.register(income);

        verify(() => repository.create(any())).called(1);

        expect(result.isSuccess(), isTrue);
        expect(result.fold((s) {}, (f) => f), isA<void>());
      });
      test("Returns a Fail when no errors occur", () async {
        when(() => repository.create(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.register(income);

        verify(() => repository.create(income)).called(1);

        expect(result.isError(), isTrue);
        expect(result.fold((s) {}, (f) => f), isA<Fail>());
      });
    });
    group("Update Method is working", () {
      group("Only update parcel when updateIncome parameter is false", () {
        test("Returns void when no erros occur", () async {
          when(() => repository.updateParcel(any()))
              .thenAnswer((_) async => const Success(2));
          when(() => repository.updateIncome(any()))
              .thenAnswer((_) async => const Success(2));

          final result = await usecase.update(newParcel: parcel);

          verify(() => repository.updateParcel(any())).called(1);
          verifyNever(() => repository.updateIncome(any()));

          expect(result.isSuccess(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<void>());
        });
        test("Returns a Fail when some error occur", () async {
          when(() => repository.updateParcel(any()))
              .thenAnswer((_) async => Failure(Fail("")));
          when(() => repository.updateIncome(any()))
              .thenAnswer((_) async => const Success(2));

          final result = await usecase.update(newParcel: parcel);

          verify(() => repository.updateParcel(any())).called(1);
          verifyNever(() => repository.updateIncome(any()));

          expect(result.isError(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<Fail>());
        });
      });
      group("Update parcel and income when parameter is true", () {
        test("Returns void when no errors occur", () async {
          when(() => repository.updateParcel(any()))
              .thenAnswer((_) async => const Success(2));
          when(() => repository.updateIncome(any()))
              .thenAnswer((_) async => const Success(2));

          final result = await usecase.update(
            newParcel: parcel,
            updateIncome: true,
          );

          verify(() => repository.updateParcel(any())).called(1);
          verify(() => repository.updateIncome(any())).called(1);

          expect(result.isSuccess(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<void>());
        });
        test("Returns a Fail when a error occur in updateParcel", () async {
          when(() => repository.updateParcel(any()))
              .thenAnswer((_) async => Failure(Fail("")));
          when(() => repository.updateIncome(any()))
              .thenAnswer((_) async => const Success(2));

          final result = await usecase.update(
            newParcel: parcel,
            updateIncome: true,
          );

          verify(() => repository.updateParcel(any())).called(1);
          verifyNever(() => repository.updateIncome(any()));

          expect(result.isError(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<Fail>());
        });
        test("Returns a Fail when a error occur in updateIncome", () async {
          when(() => repository.updateParcel(any()))
              .thenAnswer((_) async => const Success(2));
          when(() => repository.updateIncome(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.update(
            newParcel: parcel,
            updateIncome: true,
          );

          verify(() => repository.updateParcel(any())).called(1);
          verify(() => repository.updateIncome(any())).called(1);

          expect(result.isError(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<Fail>());
        });
      });
    });
    group("GetAll Method is working", () {
      test("Returns a List of Income Parcels when no errors occur", () async {
        when(() => repository.getAll(any()))
            .thenAnswer((_) async => const Success([]));

        final result = await usecase.getAll(2);

        verify(() => repository.getAll(any())).called(1);

        expect(result.isSuccess(), isTrue);
        expect(result.fold((s) => s, (f) => f), isA<List<IncomeParcel>>());
        expect(result.fold((s) => s.isEmpty, (f) => f), isTrue);
      });
      test("Returns a Fail when some error occur", () async {
        when(() => repository.getAll(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.getAll(2);

        verify(() => repository.getAll(any())).called(1);

        expect(result.isError(), isTrue);
        expect(result.fold((s) => s, (f) => f), isA<Fail>());
      });
    });
    group("Delete Method is working", () {
      group("Only delete parcel when deleteIncome parameter is false", () {
        test("Returns void when no erros occur", () async {
          when(() => repository.deleteParcel(any()))
              .thenAnswer((_) async => const Success(2));
          when(() => repository.deleteIncome(any()))
              .thenAnswer((_) async => const Success(2));

          final result = await usecase.delete(parcel: parcel);

          verify(() => repository.deleteParcel(any())).called(1);
          verifyNever(() => repository.deleteIncome(any()));

          expect(result.isSuccess(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<void>());
        });
        test("Returns a Fail when some error occur", () async {
          when(() => repository.deleteParcel(any()))
              .thenAnswer((_) async => Failure(Fail("")));
          when(() => repository.deleteIncome(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.delete(parcel: parcel);

          verify(() => repository.deleteParcel(any())).called(1);
          verifyNever(() => repository.deleteIncome(any()));

          expect(result.isError(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<Fail>());
        });
      });
      group("Delete parcel and income when the parameter is true", () {
        test("Returns void when no errors occur", () async {
          when(() => repository.deleteParcel(any()))
              .thenAnswer((_) async => const Success(2));
          when(() => repository.deleteIncome(any()))
              .thenAnswer((_) async => const Success(2));

          final result = await usecase.delete(
            parcel: parcel,
            deleteIncome: true,
          );

          verify(() => repository.deleteParcel(any())).called(1);
          verify(() => repository.deleteIncome(any())).called(1);

          expect(result.isSuccess(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<void>());
        });
        test("Returns a Fail when an error occur in deleteParcel", () async {
          when(() => repository.deleteParcel(any()))
              .thenAnswer((_) async => Failure(Fail("")));
          when(() => repository.deleteIncome(any()))
              .thenAnswer((_) async => const Success(2));

          final result = await usecase.delete(
            parcel: parcel,
            deleteIncome: true,
          );

          verify(() => repository.deleteParcel(any())).called(1);
          verifyNever(() => repository.deleteIncome(any()));

          expect(result.isError(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<Fail>());
        });
        test("Returns a Fail when an error occur in deleteExpense", () async {
          when(() => repository.deleteParcel(any()))
              .thenAnswer((_) async => const Success(2));
          when(() => repository.deleteIncome(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.delete(
            parcel: parcel,
            deleteIncome: true,
          );

          verify(() => repository.deleteParcel(any())).called(1);
          verify(() => repository.deleteIncome(any())).called(1);

          expect(result.isError(), isTrue);
          expect(result.fold((s) {}, (f) => f), isA<Fail>());
        });
      });
    });
  });
}
