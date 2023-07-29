import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/ibalance_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iincome_parcel_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iincome_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/itransaction_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/manage_income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imanage_income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../utils/factorys/income_factory.dart';
import '../../utils/factorys/income_parcel_factory.dart';
import '../../utils/factorys/transactions_factory.dart';
import '../repositories/balance_repository_mock.dart';
import '../repositories/income_parcel_repository_mock.dart';
import '../repositories/income_repository_mock.dart';
import '../repositories/transaction_repository_mock.dart';

void main() {
  late IManageIncome usecase;
  late IIncomeRepository incomeRepository;
  late IIncomeParcelRepository incomeParcelRepository;
  late IBalanceRepository balanceRepository;
  late ITransactionRepository transactionRepository;

  setUpAll(() {
    registerFallbackValue(IncomeFactory.generate());
    registerFallbackValue(IncomeParcelFactory.generate());
    registerFallbackValue(TransactionsFactory.generate());
  });

  setUp(() {
    incomeRepository = IncomeRepositoryMock();
    incomeParcelRepository = IncomeParcelRepositoryMock();
    balanceRepository = BalanceRepositoryMock();
    transactionRepository = TransactionRepositoryMock();

    usecase = ManageIncome(
      incomeRepository: incomeRepository,
      incomeParcelRepository: incomeParcelRepository,
      balanceRepository: balanceRepository,
      transactionRepository: transactionRepository,
    );
  });

  group("Manage Income Usecase is Working", () {
    group("register method", () {
      setUp(() {
        when(() => incomeRepository.create(any()))
            .thenAnswer((_) async => const Success(2));

        when(() => incomeParcelRepository.create(any()))
            .thenAnswer((_) async => const Success(2));
      });

      test("returns InvalidValue when value is equal or less than 0", () async {
        var result = await usecase.register(IncomeFactory.generate(value: 0));

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return error because value is 0',
        );
        expect(
          result.fold((s) {}, (f) => f),
          isA<InvalidValue>(),
          reason: 'The error must be a InvalidValue instance',
        );

        result = await usecase.register(IncomeFactory.generate(value: -1));

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return error because value is less 0',
        );
        expect(
          result.fold((s) {}, (f) => f),
          isA<InvalidValue>(),
          reason: 'The error must be a InvalidValue instance',
        );

        verifyNever(() => incomeRepository.create(any()));
        verifyNever(() => incomeParcelRepository.create(any()));
      });
      test("returns InvalidValue when name is empty or over the limit of 30",
          () async {
        var result = await usecase.register(IncomeFactory.generate(name: ''));

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return error because name is empty',
        );
        expect(
          result.fold((s) {}, (f) => f),
          isA<InvalidValue>(),
          reason: 'The error must be a InvalidValue instance',
        );

        result = await usecase.register(
            IncomeFactory.generate(name: 'ccccccccccccccccccccccccccccccccc'));

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return error because name length is over 30 characters',
        );
        expect(
          result.fold((s) {}, (f) => f),
          isA<InvalidValue>(),
          reason: 'The error must be a InvalidValue instance',
        );

        verifyNever(() => incomeRepository.create(any()));
        verifyNever(() => incomeParcelRepository.create(any()));
      });
      test("must call income repository to create an income", () async {
        await usecase.register(IncomeFactory.generate());

        verify(() => incomeRepository.create(any()));
      });
      test("must call income parcel repository to create an income parcel",
          () async {
        await usecase.register(IncomeFactory.generate());

        verify(() => incomeParcelRepository.create(any()));
      });

      group("returns error when", () {
        test("income repository returns error", () async {
          when(() => incomeRepository.create(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.register(IncomeFactory.generate());

          expect(
            result.isError(),
            isTrue,
            reason: 'an error happened creating income, so must return error',
          );
        });
        test("income parcel repository returns error", () async {
          when(() => incomeParcelRepository.create(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.register(IncomeFactory.generate());

          expect(
            result.isError(),
            isTrue,
            reason: 'an error happened creating parcel, so must return error',
          );
        });
      });

      test("must not create a parcel when income creation fails", () async {
        when(() => incomeRepository.create(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        await usecase.register(IncomeFactory.generate());

        verify(() => incomeRepository.create(any()));
        verifyNever(() => incomeParcelRepository.create(any()));
      });

      test("returns success when no error happens", () async {
        final result = await usecase.register(IncomeFactory.generate());

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'no error happened, so must return a success',
        );
      });
    });
    group("update income method", () {
      setUp(() {
        when(() => incomeRepository.update(any()))
            .thenAnswer((_) async => const Success(2));
      });

      test("returns success when no error happens", () async {
        final result = await usecase.updateIncome(IncomeFactory.generate());

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'No errors happened, so must return success',
        );
        verify(() => incomeRepository.update(any()));
      });

      test("returns error when an error happens", () async {
        when(() => incomeRepository.update(any()))
            .thenAnswer((_) async => Failure(Fail("")));
        final result = await usecase.updateIncome(IncomeFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason: 'An error happened in repository, so must return fail',
        );
      });
      test("returns InvalidValue when name is empty or over the limit of 30",
          () async {
        var result =
            await usecase.updateIncome(IncomeFactory.generate(name: ''));

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return error because name is empty',
        );
        expect(
          result.fold((s) {}, (f) => f),
          isA<InvalidValue>(),
          reason: 'The error must be a InvalidValue instance',
        );

        result = await usecase.updateIncome(
            IncomeFactory.generate(name: 'cccccccccccccccccccccccccccccccc'));

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return error because name length is over 30 characters',
        );
        expect(
          result.fold((s) {}, (f) => f),
          isA<InvalidValue>(),
          reason: 'The error must be a InvalidValue instance',
        );

        verifyNever(() => incomeRepository.update(any()));
      });
      test("pass the correct value to repository", () async {
        final income = IncomeFactory.generate();
        await usecase.updateIncome(income);

        verify(() => incomeRepository.update(income));
      });
    });
    group("update parcel method", () {
      setUp(() {
        when(() => incomeParcelRepository.update(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => balanceRepository.sumToExpectedBalance(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => balanceRepository.decrementFromExpectedBalance(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => balanceRepository.decrementFromActualBalance(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => transactionRepository.register(any()))
            .thenAnswer((_) async => const Success(2));
      });

      group("returns an InvalidValue when new parcel's", () {
        test("total value is equal to 0", () async {
          final result = await usecase.updateParcel(
            oldParcel: IncomeParcelFactory.generate(),
            newParcel: IncomeParcelFactory.generate(totalValue: 0),
          );

          expect(
            result.isError(),
            isTrue,
            reason: 'Must return an error because total value is equal to 0',
          );
          expect(
            result.fold((s) {}, (f) => f),
            isA<InvalidValue>(),
            reason: 'The error must be a InvalidValue instance',
          );
        });
        test("total value is less than 0", () async {
          final result = await usecase.updateParcel(
            oldParcel: IncomeParcelFactory.generate(),
            newParcel: IncomeParcelFactory.generate(totalValue: -1),
          );

          expect(
            result.isError(),
            isTrue,
            reason: 'Must return an error because total value is less than 0',
          );
          expect(
            result.fold((s) {}, (f) => f),
            isA<InvalidValue>(),
            reason: 'The error must be a InvalidValue instance',
          );
        });
      });
      test("returns error when updating parcel fails", () async {
        when(() => incomeParcelRepository.update(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.updateParcel(
          oldParcel: IncomeParcelFactory.generate(),
          newParcel: IncomeParcelFactory.generate(),
        );

        expect(
          result.isError(),
          isTrue,
          reason:
              'Must return error because an error happened updating income parcel',
        );
      });
      group("when old parcel's total value is less than new one's", () {
        final oldParcel = IncomeParcelFactory.generate(totalValue: 151.5);
        final newParcel = IncomeParcelFactory.generate(totalValue: 541.31);

        test("increments expected balance of this month", () async {
          await usecase.updateParcel(
            oldParcel: oldParcel,
            newParcel: newParcel,
          );

          verify(() => balanceRepository.sumToExpectedBalance(389.81));
        });
        test("returns an error if balance repository fails", () async {
          when(() => balanceRepository.sumToExpectedBalance(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.updateParcel(
            oldParcel: oldParcel,
            newParcel: newParcel,
          );

          expect(
            result.isError(),
            isTrue,
            reason: 'Must return an error because balance repository failed',
          );
        });
      });
      group("when old parcel's total value is greater than new one's", () {
        final oldParcel = IncomeParcelFactory.generate(totalValue: 326.12);
        final newParcel = IncomeParcelFactory.generate(totalValue: 151.9);

        test("returns error when decrementing expected balance fails",
            () async {
          when(() => balanceRepository.decrementFromExpectedBalance(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.updateParcel(
            oldParcel: oldParcel,
            newParcel: newParcel,
          );

          expect(
            result.isError(),
            isTrue,
            reason: 'Decrementing expected balance failed, must return error',
          );
        });
        test("decrement expected balance of this month", () async {
          when(() => balanceRepository.decrementFromExpectedBalance(any()))
              .thenAnswer((_) async => const Success(2));

          final result = await usecase.updateParcel(
            oldParcel: oldParcel,
            newParcel: newParcel,
          );

          expect(
            result.isSuccess(),
            isTrue,
            reason: 'No errors happened, must return success',
          );

          verify(() => balanceRepository.decrementFromExpectedBalance(174.22));
        });
        group("if old one's paid value is greater than new one's total value",
            () {
          final oldPaidParcel = IncomeParcelFactory.generate(
            totalValue: 563.55,
            paidValue: 400.0,
          );

          test("decrement actual balance", () async {
            await usecase.updateParcel(
              oldParcel: oldPaidParcel,
              newParcel: newParcel,
            );

            verify(() => balanceRepository.decrementFromActualBalance(248.10));
          });
          test("return error if balance repository returns error", () async {
            when(() => balanceRepository.decrementFromActualBalance(any()))
                .thenAnswer((_) async => Failure(Fail("")));

            final result = await usecase.updateParcel(
              oldParcel: oldPaidParcel,
              newParcel: newParcel,
            );

            expect(
              result.isError(),
              isTrue,
              reason:
                  'Must return an error because balance repository returned error',
            );
          });
          test("register a new transaction", () async {
            await usecase.updateParcel(
              oldParcel: oldPaidParcel,
              newParcel: newParcel,
            );

            verify(() => transactionRepository.register(any()));
          });
          test("return error if transaction repository returns error",
              () async {
            when(() => transactionRepository.register(any()))
                .thenAnswer((_) async => Failure(Fail("")));

            final result = await usecase.updateParcel(
              oldParcel: oldPaidParcel,
              newParcel: newParcel,
            );

            expect(
              result.isError(),
              isTrue,
              reason:
                  'Must return an error because transaction repository returned error',
            );
          });
        });
      });
    });
    group("get all of method", () {
      setUp(() {
        when(() =>
            incomeParcelRepository.getAllOf(
                month: any(named: 'month'),
                year: any(named: 'year'))).thenAnswer((_) async =>
            Success(List.generate(8, (_) => IncomeParcelFactory.generate())));
      });

      group("returns DateError when", () {
        test("month is invalid", () async {
          var result = await usecase.getAllOf(month: 0, year: 2023);

          expect(
            result.isError(),
            isTrue,
            reason: 'Must return an error because month is less than 1',
          );
          expect(
            result.fold((s) => s, (f) => f),
            isA<DateError>(),
            reason: 'The error must be a DateError instance',
          );

          result = await usecase.getAllOf(month: -1, year: 2023);

          expect(
            result.isError(),
            isTrue,
            reason: 'Must return an error because month is less than 1',
          );
          expect(
            result.fold((s) => s, (f) => f),
            isA<DateError>(),
            reason: 'The error must be a DateError instance',
          );

          result = await usecase.getAllOf(month: 13, year: 2023);

          expect(
            result.isError(),
            isTrue,
            reason: 'Must return an error because month is greater than 12',
          );
          expect(
            result.fold((s) => s, (f) => f),
            isA<DateError>(),
            reason: 'The error must be a DateError instance',
          );
        });
        test("year is invalid", () async {
          final result = await usecase.getAllOf(month: 5, year: 1999);

          expect(
            result.isError(),
            isTrue,
            reason: 'Must return an error because year is less than 2000',
          );
          expect(
            result.fold((s) => s, (f) => f),
            isA<DateError>(),
            reason: 'The error must be a DateError instance',
          );
        });
      });
      test("returns error when income parcel repository fails", () async {
        when(() => incomeParcelRepository.getAllOf(
                month: any(named: 'month'), year: any(named: 'year')))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.getAllOf(month: 1, year: 2021);

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return an error because repository failed',
        );

        verify(() => incomeParcelRepository.getAllOf(
            month: any(named: 'month'), year: any(named: 'year')));
      });
      test("returns success when no error happens", () async {
        final result = await usecase.getAllOf(month: 1, year: 2021);

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'Must return a success because no errors happened',
        );

        verify(() => incomeParcelRepository.getAllOf(
            month: any(named: 'month'), year: any(named: 'year')));
      });
    });
    group("delete income method", () {
      setUp(() {
        when(() => incomeRepository.delete(any()))
            .thenAnswer((_) async => const Success(2));
      });

      test("returns error when income repository fails", () async {
        when(() => incomeRepository.delete(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.deleteIncome(IncomeFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return error because income repository failed',
        );
      });

      test("returns success when no errors happens", () async {
        final result = await usecase.deleteIncome(IncomeFactory.generate());

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'Must return success because no errors happened',
        );
      });
    });
    group("delete parcel method", () {
      setUp(() {
        when(() => incomeParcelRepository.delete(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => balanceRepository.decrementFromExpectedBalance(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => balanceRepository.decrementFromActualBalance(any()))
            .thenAnswer((_) async => const Success(2));
      });
      test("returns success when no error happens", () async {
        final result =
            await usecase.deleteParcel(IncomeParcelFactory.generate());

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'Must return success because no errors happened',
        );
      });
      test("returns error when deleting parcel fails", () async {
        when(() => incomeParcelRepository.delete(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        final result =
            await usecase.deleteParcel(IncomeParcelFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return error because repository failed deleting parcel',
        );

        verify(() => incomeParcelRepository.delete(any()));
      });
      test("returns error when decrementing expected balance fails", () async {
        when(() => balanceRepository.decrementFromExpectedBalance(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        final result =
            await usecase.deleteParcel(IncomeParcelFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason:
              'Must return error because repository failed decrementing expected balance',
        );

        verify(() => balanceRepository.decrementFromExpectedBalance(any()));
      });
      test("decrements the correct value from expected balance", () async {
        final parcel = IncomeParcelFactory.generate();

        await usecase.deleteParcel(parcel);

        verify(() =>
            balanceRepository.decrementFromExpectedBalance(parcel.totalValue));
      });
      group("when some value of parcel was paid", () {
        test("decrements actual balance", () async {
          await usecase.deleteParcel(IncomeParcelFactory.generateReceived());

          verify(() => balanceRepository.decrementFromActualBalance(any()));
        });
        test("decrements the correct value", () async {
          final parcel = IncomeParcelFactory.generateReceived();
          await usecase.deleteParcel(parcel);

          verify(() =>
              balanceRepository.decrementFromActualBalance(parcel.paidValue));
        });
        test("returns error when decrementing actual balance fails", () async {
          when(() => balanceRepository.decrementFromActualBalance(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase
              .deleteParcel(IncomeParcelFactory.generateReceived());

          expect(
            result.isError(),
            isTrue,
            reason:
                'Must return error because repository failed decrementing actual balance',
          );

          verify(() => balanceRepository.decrementFromActualBalance(any()));
        });
      });
    });
  });
}
