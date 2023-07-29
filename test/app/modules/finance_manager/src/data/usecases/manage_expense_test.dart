import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/ibalance_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_parcel_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/ipayment_method_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/itransaction_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/manage_expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imanage_expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import '../../utils/factorys/expense_factory.dart';
import '../../utils/factorys/expense_parcel_factory.dart';
import '../../utils/factorys/transactions_factory.dart';
import '../repositories/balance_repository_mock.dart';
import '../repositories/expense_parcel_repository_mock.dart';
import '../repositories/expense_repository_mock.dart';
import '../repositories/payment_method_repository_mock.dart';
import '../repositories/transaction_repository_mock.dart';

void main() {
  late IManageExpense usecase;
  late IExpenseRepository expenseRepository;
  late IExpenseParcelRepository expenseParcelRepository;
  late IBalanceRepository balanceRepository;
  late ITransactionRepository transactionRepository;
  late IPaymentMethodRepository paymentMethodRepository;

  setUpAll(() {
    registerFallbackValue(ExpenseFactory.generate());
    registerFallbackValue(ExpenseParcelFactory.generate());
    registerFallbackValue(TransactionsFactory.generate());
  });

  setUp(() {
    expenseRepository = ExpenseRepositoryMock();
    expenseParcelRepository = ExpenseParcelRepositoryMock();
    balanceRepository = BalanceRepositoryMock();
    transactionRepository = TransactionRepositoryMock();
    paymentMethodRepository = PaymentMethodRepositoryMock();

    usecase = ManageExpense(
      expenseRepository: expenseRepository,
      expenseParcelRepository: expenseParcelRepository,
      balanceRepository: balanceRepository,
      transactionRepository: transactionRepository,
      paymentMethodRepository: paymentMethodRepository,
    );
  });

  group("Manage Expense Usecase is Working", () {
    group("create method", () {
      setUp(() {
        when(() => expenseRepository.create(any()))
            .thenAnswer((_) async => const Success(2));

        when(() => expenseParcelRepository.create(any()))
            .thenAnswer((_) async => const Success(2));
      });

      test("returns InvalidValue when value is equal or less than 0", () async {
        var result = await usecase.register(ExpenseFactory.generate(value: 0));

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

        result = await usecase.register(ExpenseFactory.generate(value: -1));

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

        verifyNever(() => expenseRepository.create(any()));
        verifyNever(() => expenseParcelRepository.create(any()));
      });
      test("returns InvalidValue when string is empty or over the limit of 30",
          () async {
        var result = await usecase.register(ExpenseFactory.generate(name: ''));

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
            ExpenseFactory.generate(name: 'abababababababababababababababab'));

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

        verifyNever(() => expenseRepository.create(any()));
        verifyNever(() => expenseParcelRepository.create(any()));
      });
      test("must call expense repository to create an expense", () async {
        await usecase
            .register(ExpenseFactory.generate(dueDate: DateTime.now()));

        verify(() => expenseRepository.create(any()));
      });
      test("must call expense parcel repository to create an expense parcel",
          () async {
        await usecase
            .register(ExpenseFactory.generate(dueDate: DateTime.now()));

        verify(() => expenseParcelRepository.create(any()));
      });

      group("returns error when", () {
        test("expense repository returns error", () async {
          when(() => expenseRepository.create(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase
              .register(ExpenseFactory.generate(dueDate: DateTime.now()));

          expect(
            result.isError(),
            isTrue,
            reason: 'an error happened creating expense, so must return error',
          );
        });
        test("expense parcel repository returns error", () async {
          when(() => expenseParcelRepository.create(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase
              .register(ExpenseFactory.generate(dueDate: DateTime.now()));

          expect(
            result.isError(),
            isTrue,
            reason: 'an error happened creating parcel, so must return error',
          );
        });
      });

      test("must not create a parcel when expense creation fails", () async {
        when(() => expenseRepository.create(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        await usecase.register(ExpenseFactory.generate());

        verify(() => expenseRepository.create(any()));
        verifyNever(() => expenseParcelRepository.create(any()));
      });

      test("returns success when no error happens", () async {
        final result = await usecase.register(ExpenseFactory.generate());

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'no error happened, so must return a success',
        );
      });
    });
    group("update expense method", () {
      setUp(() {
        when(() => expenseRepository.update(any()))
            .thenAnswer((_) async => const Success(2));
      });

      test("returns success when no error happens", () async {
        final result = await usecase.updateExpense(ExpenseFactory.generate());

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'No errors happened, so must return success',
        );
        verify(() => expenseRepository.update(any()));
      });

      test("returns error when an error happens", () async {
        when(() => expenseRepository.update(any()))
            .thenAnswer((_) async => Failure(Fail("")));
        final result = await usecase.updateExpense(ExpenseFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason: 'An error happened in repository, so must return fail',
        );
      });
      test("returns InvalidValue when string is empty or over the limit of 30",
          () async {
        var result =
            await usecase.updateExpense(ExpenseFactory.generate(name: ''));

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

        result = await usecase.updateExpense(
            ExpenseFactory.generate(name: 'abababababababababababababababab'));

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

        verifyNever(() => expenseRepository.update(any()));
      });
      test("pass the correct value to repository", () async {
        final expense = ExpenseFactory.generate();
        await usecase.updateExpense(expense);

        verify(() => expenseRepository.update(expense));
      });
    });
    group("update parcel method", () {
      setUp(() {
        when(() => expenseParcelRepository.update(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => balanceRepository.sumToActualBalance(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => balanceRepository.sumToExpectedBalance(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => balanceRepository.decrementFromExpectedBalance(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => transactionRepository.register(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => paymentMethodRepository.getValuePaidWithCredit(any()))
            .thenAnswer((_) async => const Success(0.0));
        when(() => paymentMethodRepository.removeValueFromNoCreditPayMethods(
            any())).thenAnswer((_) async => const Success(2));
      });

      test("returns success when no error happens", () async {
        final result = await usecase.updateParcel(
          oldParcel: ExpenseParcelFactory.generate(),
          newParcel: ExpenseParcelFactory.generate(),
        );

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'No errors happened, so must return success',
        );
      });

      group("returns InvalidValue when new parcel's", () {
        test("total value is equal to 0", () async {
          final result = await usecase.updateParcel(
            oldParcel: ExpenseParcelFactory.generate(),
            newParcel: ExpenseParcelFactory.generate(totalValue: 0.0),
          );

          expect(
            result.isError(),
            isTrue,
            reason: 'Total Value is equal to 0, must return error',
          );
          expect(
            result.fold((s) => {}, (f) => f),
            isA<InvalidValue>(),
            reason: 'The error returned must be an InvalidValue instance',
          );
        });
        test("total value is less than 0", () async {
          final result = await usecase.updateParcel(
            oldParcel: ExpenseParcelFactory.generate(),
            newParcel: ExpenseParcelFactory.generate(totalValue: 0.0),
          );

          expect(
            result.isError(),
            isTrue,
            reason: 'Total value is less than 0, must return error',
          );
          expect(
            result.fold((s) => {}, (f) => f),
            isA<InvalidValue>(),
            reason: 'The error returned must be an InvalidValue instance',
          );
        });
      });

      test("returns error when an error happens in parcel repository",
          () async {
        when(() => expenseParcelRepository.update(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.updateParcel(
          oldParcel: ExpenseParcelFactory.generate(),
          newParcel: ExpenseParcelFactory.generate(),
        );

        expect(
          result.isError(),
          isTrue,
          reason: 'An error happened in parcel repository, must return fail',
        );
      });
      group("when old parcel's total value is less than new one's", () {
        final oldParcel = ExpenseParcelFactory.generate(totalValue: 300.0);
        final newParcel = ExpenseParcelFactory.generate(totalValue: 431.0);

        test("decrements expected balance of this month", () async {
          await usecase.updateParcel(
            oldParcel: oldParcel,
            newParcel: newParcel,
          );

          verify(() => balanceRepository.decrementFromExpectedBalance(131.0));
        });
        test("returns an error if balance repository fails", () async {
          when(() => balanceRepository.decrementFromExpectedBalance(any()))
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
        final oldParcel = ExpenseParcelFactory.generate(totalValue: 563.55);
        final newParcel =
            ExpenseParcelFactory.generate(totalValue: 300.00, paidValue: 0.0);

        test("returns error when updating expected balance fails", () async {
          when(() => balanceRepository.sumToExpectedBalance(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.updateParcel(
            oldParcel: oldParcel,
            newParcel: newParcel,
          );

          expect(
            result.isError(),
            isTrue,
            reason: 'Updating expected parcel failed, must return error',
          );
        });
        test("update expected balance of this month", () async {
          when(() => balanceRepository.sumToExpectedBalance(any()))
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

          verify(() => balanceRepository.sumToExpectedBalance(263.55));
        });
        group("if old one's paid value is greater than new one's total value",
            () {
          final oldPaidParcel = ExpenseParcelFactory.generate(
            totalValue: 563.55,
            paidValue: 400.0,
          );

          test(
            "if value paid with credit is greater than new one's total value, returns error",
            () async {
              when(() => paymentMethodRepository.getValuePaidWithCredit(any()))
                  .thenAnswer((_) async => const Success(400.0));

              final result = await usecase.updateParcel(
                oldParcel: oldPaidParcel,
                newParcel: newParcel,
              );

              expect(
                result.isError(),
                isTrue,
                reason:
                    'The value paid with Credit is greater than new total value, mus return a fail',
              );

              expect(
                result.fold((s) {}, (f) => f),
                isA<CreditError>(),
                reason: 'The error returned must be a CreditError instance',
              );
            },
          );
          test("returns error if an error happens in payment method repository",
              () async {
            when(() => paymentMethodRepository.getValuePaidWithCredit(any()))
                .thenAnswer((_) async => Failure(Fail("")));

            final result = await usecase.updateParcel(
              oldParcel: oldPaidParcel,
              newParcel: newParcel,
            );

            expect(
              result.isError(),
              isTrue,
              reason:
                  'An error happened obtaining value paid with credit, must return error',
            );
          });
          test("update actual balance", () async {
            await usecase.updateParcel(
              oldParcel: oldPaidParcel,
              newParcel: newParcel,
            );

            verify(() => balanceRepository.sumToActualBalance(100.0));
          });
          test("return error if balance repository returns error", () async {
            when(() => balanceRepository.sumToActualBalance(any()))
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
          test("remove value from payment methods used to pay the parcel",
              () async {
            await usecase.updateParcel(
              oldParcel: oldPaidParcel,
              newParcel: newParcel,
            );

            verify(() => paymentMethodRepository
                .removeValueFromNoCreditPayMethods(263.55));
          });
          test("returns error when removing value from payment methods fails",
              () async {
            when(() => paymentMethodRepository
                    .removeValueFromNoCreditPayMethods(any()))
                .thenAnswer((_) async => Failure(Fail("")));
            final result = await usecase.updateParcel(
              oldParcel: oldPaidParcel,
              newParcel: newParcel,
            );

            expect(
              result.isError(),
              isTrue,
              reason:
                  'Must return error because an error happened removing value from payment methods',
            );
          });
          test("generates a new adjust transaction", () async {
            await usecase.updateParcel(
              oldParcel: oldPaidParcel,
              newParcel: newParcel,
            );

            verify(() => transactionRepository.register(any()));
          });
        });
      });
    });
    group("get all of method", () {
      setUp(() {
        when(() =>
            expenseParcelRepository.getAllOf(
                month: any(named: 'month'),
                year: any(named: 'year'))).thenAnswer((_) async =>
            Success(List.generate(8, (_) => ExpenseParcelFactory.generate())));
      });

      test("returns DateError when month or year is invalid", () async {
        var result = await usecase.getAllOf(month: 0, year: 2023);

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return error because month is less than 1',
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
          reason: 'Must return error because month is greater than 12',
        );
        expect(
          result.fold((s) => s, (f) => f),
          isA<DateError>(),
          reason: 'The error must be a DateError instance',
        );
        result = await usecase.getAllOf(month: 8, year: 1999);

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return error because year is less than 2000',
        );
        expect(
          result.fold((s) => s, (f) => f),
          isA<DateError>(),
          reason: 'The error must be a DateError instance',
        );
      });
      test("returns error when expense parcel repository fails", () async {
        when(() => expenseParcelRepository.getAllOf(
                month: any(named: 'month'), year: any(named: 'year')))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.getAllOf(month: 2, year: 2020);

        expect(
          result.isError(),
          isTrue,
          reason: 'Repository failed, so must return an error',
        );
      });
      test("returns success when no error happens", () async {
        final result = await usecase.getAllOf(month: 2, year: 2020);

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'Repository returned success, so must return success',
        );
        expect(
          result.fold((s) => s.length, (f) => f),
          equals(8),
          reason:
              "The list returned must have the same lengtha as repository's list",
        );
      });
      test("calls expense parcel repository with correct values", () async {
        await usecase.getAllOf(month: 4, year: 2025);

        verify(() => expenseParcelRepository.getAllOf(month: 4, year: 2025));
      });
    });
    group("delete expense method", () {
      setUp(() {
        when(() => expenseRepository.delete(any()))
            .thenAnswer((_) async => const Success(2));
      });
      test("returns error when expense repository fails", () async {
        when(() => expenseRepository.delete(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.deleteExpense(ExpenseFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return error because repository failed',
        );

        verify(() => expenseRepository.delete(any()));
      });
      test("returns success when no error happens", () async {
        final result = await usecase.deleteExpense(ExpenseFactory.generate());

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'Must return success because no errors happened',
        );

        verify(() => expenseRepository.delete(any()));
      });
      test("calls expense repository with correct expense", () async {
        final expense = ExpenseFactory.generate();
        await usecase.deleteExpense(expense);

        verify(() => expenseRepository.delete(expense));
      });
    });
    group("delete parcel method", () {
      setUp(() {
        when(() => expenseParcelRepository.delete(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => balanceRepository.sumToActualBalance(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => balanceRepository.sumToExpectedBalance(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => transactionRepository);
      });

      test("returns error when parcel repository fail deleting parcel",
          () async {
        when(() => expenseParcelRepository.delete(any()))
            .thenAnswer((_) async => Failure(Fail("")));
        final result =
            await usecase.deleteParcel(ExpenseParcelFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return error because deleting parcel failed',
        );

        verify(() => expenseParcelRepository.delete(any()));
      });
      test(
          "returns error when balance repository fail updating expected balance",
          () async {
        when(() => balanceRepository.sumToExpectedBalance(any()))
            .thenAnswer((_) async => Failure(Fail("")));
        final result =
            await usecase.deleteParcel(ExpenseParcelFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return error because updating expected balance failed',
        );

        verify(() => balanceRepository.sumToExpectedBalance(any()));
      });

      test("calls  balance repository with the correct values", () async {
        await usecase
            .deleteParcel(ExpenseParcelFactory.generate(totalValue: 543.21));

        verify(() => balanceRepository.sumToExpectedBalance(543.21));
      });

      test("returns success when no error happens", () async {
        final result =
            await usecase.deleteParcel(ExpenseParcelFactory.generate());

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'Must return success because no errors happened',
        );
      });

      group("when parcel was partially or tatally paid", () {
        test("update the actual balance", () async {
          var parcel = ExpenseParcelFactory.generatePaidParcel();
          var result = await usecase.deleteParcel(parcel);

          expect(
            result.isSuccess(),
            isTrue,
            reason: 'Must return success because no errors happened',
          );

          verify(() => balanceRepository.sumToActualBalance(parcel.paidValue));

          parcel = ExpenseParcelFactory.generate(
              totalValue: 521.1, paidValue: 102.43);

          result = await usecase.deleteParcel(parcel);

          expect(
            result.isSuccess(),
            isTrue,
            reason: 'Must return success because no errors happened',
          );

          verify(() => balanceRepository.sumToActualBalance(102.43));
        });
        test("returns error when repository fails updating actual balance",
            () async {
          when(() => balanceRepository.sumToActualBalance(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase
              .deleteParcel(ExpenseParcelFactory.generatePaidParcel());

          expect(
            result.isError(),
            isTrue,
            reason:
                'Must return error because an error happened updating actual balance',
          );
        });
      });
    });
  });
}
