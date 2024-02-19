import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/ibalance_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iincome_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iinstallment_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iinvoice_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/gets/get_balance.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/gets/iget_balance.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';

import '../../repositories/balance_repository_mock.dart';
import '../../repositories/expense_repository_mock.dart';
import '../../repositories/income_repository_mock.dart';
import '../../repositories/installment_repository_mock.dart';
import '../../repositories/invoice_repository_mock.dart';

void main() {
  late IGetBalance usecase;
  late IBalanceRepository balanceRepository;
  late IExpenseRepository expenseRepository;
  late IIncomeRepository incomeRepository;
  late IInvoiceRepository invoiceRepository;
  late IInstallmentRepository installmentRepository;

  setUpAll(() {
    registerFallbackValue(Frequency.monthly);
    registerFallbackValue(Date.today());
  });

  setUp(() {
    balanceRepository = BalanceRepositoryMock();
    expenseRepository = ExpenseRepositoryMock();
    incomeRepository = IncomeRepositoryMock();
    invoiceRepository = InvoiceRepositoryMock();
    installmentRepository = InstallmentRepositoryMock();

    usecase = GetBalance(
      balanceRepository: balanceRepository,
      expenseRepository: expenseRepository,
      incomeRepository: incomeRepository,
      invoiceRepository: invoiceRepository,
      installmentRepository: installmentRepository,
    );
  });

  group("Get Balance Usecase is Working", () {
    group("Getter 'actual'", () {
      setUp(() {
        when(() => balanceRepository.getActualBalanceOf(
                month: any(named: 'month'), year: any(named: 'year')))
            .thenAnswer((_) async => const Success(1400));
      });
      test("returns the balance of actual month if no error happens", () async {
        final result = await usecase.actual;

        verify(() => balanceRepository.getActualBalanceOf(
            month: any(named: 'month'), year: any(named: 'year'))).called(1);

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'Must return a value when no error happens in repository',
        );
      });
      test("returns a Fail if an error happens in repository", () async {
        final fail = Fail("");
        when(() => balanceRepository.getActualBalanceOf(
            month: any(named: 'month'),
            year: any(named: 'year'))).thenAnswer((_) async => Failure(fail));

        final result = await usecase.actual;

        verify(() => balanceRepository.getActualBalanceOf(
            month: any(named: 'month'), year: any(named: 'year'))).called(1);

        expect(result.isError(), isTrue);
        expect(
          result.fold((s) => s, (f) => f),
          equals(fail),
          reason: 'The fail returned must be the same returned by repository',
        );
      });
      test("returns the exactly same value returned by repository", () async {
        var result = await usecase.actual;

        expect(result.isSuccess(), isTrue);
        expect(result.fold((s) => s, (f) => f), equals(1400));

        when(() => balanceRepository.getActualBalanceOf(
                month: any(named: 'month'), year: any(named: 'year')))
            .thenAnswer((_) async => const Success(2987.61));

        result = await usecase.actual;

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'If no error happens in repository, must return a value',
        );
        expect(
          result.fold((s) => s, (f) => f),
          equals(2987.61),
          reason: 'The value must be the same returned by repository',
        );

        verify(() => balanceRepository.getActualBalanceOf(
            month: any(named: 'month'), year: any(named: 'year'))).called(2);
      });
      test("calls repository passing the actual month and year", () async {
        int month = Date.today().month;
        int year = Date.today().year;

        await usecase.actual;

        verify(() => balanceRepository.getActualBalanceOf(
              month: month,
              year: year,
            )).called(1);
      });
    });
    group("Getter 'expected'", () {
      setUp(() {
        when(() => balanceRepository.getExpectedBalanceOf(
                month: any(named: 'month'), year: any(named: 'year')))
            .thenAnswer((_) async => const Success(321.76));
      });
      test("returns the expected balance of actual month if no error happens",
          () async {
        final result = await usecase.expected;

        verify(() => balanceRepository.getExpectedBalanceOf(
            month: any(named: 'month'), year: any(named: 'year'))).called(1);

        expect(result.isSuccess(), isTrue);
      });
      test("returns a Fail if an error happens in repository", () async {
        final fail = Fail("");
        when(() => balanceRepository.getExpectedBalanceOf(
            month: any(named: 'month'),
            year: any(named: 'year'))).thenAnswer((_) async => Failure(fail));

        final result = await usecase.expected;

        verify(() => balanceRepository.getExpectedBalanceOf(
            month: any(named: 'month'), year: any(named: 'year'))).called(1);

        expect(
          result.isError(),
          isTrue,
          reason: 'If repository returns an error, must return the error',
        );
        expect(
          result.fold((s) => s, (f) => f),
          equals(fail),
          reason: 'The error returned must be the same returned by repository',
        );
      });

      test("returns the exactly same value returned by repository", () async {
        var result = await usecase.expected;

        expect(result.isSuccess(), isTrue);
        expect(
          result.fold((s) => s, (f) => f),
          equals(321.76),
          reason:
              'The value returned by usecase must be the same returned by the repository',
        );

        when(() => balanceRepository.getExpectedBalanceOf(
                month: any(named: 'month'), year: any(named: 'year')))
            .thenAnswer((_) async => const Success(1092.17));

        result = await usecase.expected;

        expect(result.isSuccess(), isTrue);
        expect(
          result.fold((s) => s, (f) => f),
          equals(1092.17),
          reason:
              'The value returned by repository must be the same returned by the usecase',
        );

        verify(() => balanceRepository.getExpectedBalanceOf(
            month: any(named: 'month'), year: any(named: 'year'))).called(2);
      });
      test("calls repository passing the actual month and year", () async {
        int month = Date.today().month;
        int year = Date.today().year;

        await usecase.expected;

        verify(() => balanceRepository.getExpectedBalanceOf(
              month: month,
              year: year,
            )).called(1);
      });
    });
    group("Get Initial Value Of method", () {
      setUp(() {
        when(() => balanceRepository.getInitialBalanceOf(
                month: any(named: 'month'), year: any(named: 'year')))
            .thenAnswer((_) async => const Success(100.65));
      });
      test("returns a DateError if month or year is invalid", () async {
        var result = await usecase.initialBalanceOf(month: 0, year: 2023);

        expect(
          result.isError(),
          isTrue,
          reason: 'The month must not be less than 1',
        );
        expect(
          result.fold((s) => s, (f) => f),
          isA<DateError>(),
          reason: 'The error must be a DateError instance',
        );

        result = await usecase.initialBalanceOf(month: 13, year: 2023);

        expect(
          result.isError(),
          isTrue,
          reason: 'The month must not be greater than 12',
        );
        expect(
          result.fold((s) => s, (f) => f),
          isA<DateError>(),
          reason: 'The error must be a DateError instance',
        );

        result = await usecase.initialBalanceOf(month: 2, year: 1999);

        expect(
          result.isError(),
          isTrue,
          reason: 'The year must not be less than 2000',
        );
        expect(
          result.fold((s) => s, (f) => f),
          isA<DateError>(),
          reason: 'The error must be a DateError instance',
        );

        result = await usecase.initialBalanceOf(month: -2, year: 1876);

        expect(
          result.isError(),
          isTrue,
          reason:
              'The month must not be less than 12 neither year less than 2000',
        );
        expect(
          result.fold(
            (s) => s,
            (f) => f,
          ),
          isA<DateError>(),
          reason: 'The error must be a DateError instance',
        );

        verifyNever(() => balanceRepository.getInitialBalanceOf(
            month: any(named: 'month'), year: any(named: 'year')));
      });

      test("returns the initial balance of a past month if no error happens",
          () async {
        final result = await usecase.initialBalanceOf(month: 1, year: 2023);

        verify(() => balanceRepository.getInitialBalanceOf(
            month: any(named: 'month'), year: any(named: 'year'))).called(1);

        expect(result.isSuccess(), isTrue);
        expect(result.fold((s) => s, (f) => f), isA<double>());
      });

      test("returns the same value returned by repository", () async {
        var result = await usecase.initialBalanceOf(month: 1, year: 2023);

        expect(result.isSuccess(), isTrue);
        expect(result.fold((s) => s, (f) => f), isA<double>());
        expect(
          result.fold((s) => s, (f) => f),
          equals(100.65),
          reason:
              'The returned value must be the same returned by repository(100.65)',
        );

        when(() => balanceRepository.getInitialBalanceOf(
                month: any(named: 'month'), year: any(named: 'year')))
            .thenAnswer((_) async => const Success(791.32));

        result = await usecase.initialBalanceOf(month: 4, year: 2023);

        expect(result.isSuccess(), isTrue);
        expect(result.fold((s) => s, (f) => f), isA<double>());
        expect(
          result.fold((s) => s, (f) => f),
          equals(791.32),
          reason:
              'The returned value must be the same returned by repository(791.32)',
        );
        verify(() => balanceRepository.getInitialBalanceOf(
            month: any(named: 'month'), year: any(named: 'year'))).called(2);
      });
      test("returns repository's Fail if an error happens in repository",
          () async {
        final fail = Fail("");
        when(() => balanceRepository.getInitialBalanceOf(
            month: any(named: 'month'),
            year: any(named: 'year'))).thenAnswer((_) async => Failure(fail));

        final result = await usecase.initialBalanceOf(month: 1, year: 2023);

        verify(() => balanceRepository.getInitialBalanceOf(
            month: any(named: 'month'), year: any(named: 'year'))).called(1);

        expect(
          result.isError(),
          isTrue,
          reason:
              'If balance repository returns an error, must return an error',
        );
        expect(
          result.fold((s) => s, (f) => f),
          equals(fail),
          reason: 'The error returned must be the same returned by repository',
        );
      });
      test("calls repository passing the correct month and year", () async {
        await usecase.initialBalanceOf(month: 5, year: 2022);

        verify(
          () => balanceRepository.getInitialBalanceOf(month: 5, year: 2022),
        ).called(1);
      });
    });
    group("Get Expected Value Of method", () {
      final date = Date.today();
      setUp(() {
        when(() => balanceRepository.getExpectedBalanceOf(
              month: any(named: 'month'),
              year: any(named: 'year'),
            )).thenAnswer((_) async => const Success(1400));
        when(() => expenseRepository.getSumOfExpensesWithFrequency(any()))
            .thenAnswer((_) async => const Success(1700));
        when(() => incomeRepository.getSumOfIncomesWithFrequency(any()))
            .thenAnswer((_) async => const Success(1700));
        when(() => invoiceRepository.getSumOfInvoicesInRange(
                inferiorLimit: any(named: 'inferiorLimit'),
                upperLimit: any(named: 'upperLimit')))
            .thenAnswer((_) async => const Success(230));
        when(() => installmentRepository.getSumOfInstallmentParcelsInRange(
              inferiorLimit: any(named: 'inferiorLimit'),
              upperLimit: any(named: 'upperLimit'),
            )).thenAnswer((_) async => const Success(203.76));
        when(() => incomeRepository.getSumOfYearlyIncomesInRange(
                inferiorLimit: any(named: 'inferiorLimit'),
                upperLimit: any(named: 'upperLimit')))
            .thenAnswer((_) async => const Success(0));
        when(() => expenseRepository.getSumOfYearlyExpensesInRange(
                inferiorLimit: any(named: 'inferiorLimit'),
                upperLimit: any(named: 'upperLimit')))
            .thenAnswer((_) async => const Success(0));
      });
      test("returns a DateError if the month or year is invalid", () async {
        var result = await usecase.expectedBalanceOf(month: -1, year: 2022);

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return a fail because month is less than 1',
        );
        expect(
          result.fold((s) => s, (f) => f),
          isA<DateError>(),
          reason: 'The fail must be a DateError',
        );

        result = await usecase.expectedBalanceOf(month: 13, year: 2022);

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return a fail because month is greater than 12',
        );
        expect(
          result.fold((s) => s, (f) => f),
          isA<DateError>(),
          reason: 'The fail must be a DateError',
        );

        result = await usecase.expectedBalanceOf(month: 5, year: 1999);

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return a fail because year is less than 2000',
        );
        expect(
          result.fold((s) => s, (f) => f),
          isA<DateError>(),
          reason: 'The fail must be a DateError',
        );

        result = await usecase.expectedBalanceOf(month: -10, year: 1972);

        expect(
          result.isError(),
          isTrue,
          reason:
              'Must return a fail because year is less than 2000 and month is less than 1',
        );
        expect(
          result.fold((s) => s, (f) => f),
          isA<DateError>(),
          reason: 'The fail must be a DateError',
        );

        verifyNever(() => balanceRepository.getExpectedBalanceOf(
            month: any(named: 'month'), year: any(named: 'year')));
      });
      test("returns the expected balance of a month if no error happens",
          () async {
        final date = Date.today();
        final date1MonthBefore = date.subtract(months: 1);
        final date1MonthAfter = date.add(months: 1);
        var result = await usecase.expectedBalanceOf(
          month: date1MonthBefore.month,
          year: date1MonthBefore.year,
        );

        expect(
          result.isSuccess(),
          isTrue,
          reason:
              'With this data and not happening errors in repositories, must return a value',
        );

        result = await usecase.expectedBalanceOf(
          month: date1MonthAfter.month,
          year: date1MonthAfter.year,
        );

        expect(
          result.isSuccess(),
          isTrue,
          reason:
              'With this data and not happening errors in repositories, must return a value',
        );
      });

      group("when date is before or same as actual date", () {
        final dateBefore = date.subtract(months: 1);
        test(
            "returns a Fail when fetching expected balance and an error happens",
            () async {
          when(() => balanceRepository.getExpectedBalanceOf(
                  month: any(named: 'month'), year: any(named: 'year')))
              .thenAnswer((_) async => Failure(Fail("")));

          var result = await usecase.expectedBalanceOf(
            month: dateBefore.month,
            year: dateBefore.year,
          );

          expect(
            result.isError(),
            isTrue,
            reason: 'Must return error because repository returned an error',
          );

          result = await usecase.expectedBalanceOf(
            month: Date.today().month,
            year: Date.today().year,
          );

          expect(
            result.isError(),
            isTrue,
            reason: 'Must return error because repository returned an error',
          );
        });
        test("returns the value when no error happens", () async {
          var result = await usecase.expectedBalanceOf(
            month: dateBefore.month,
            year: dateBefore.year,
          );

          expect(
            result.isSuccess(),
            isTrue,
            reason: 'Repository returned the expected value of past month',
          );

          expect(
            result.fold((s) => s, (f) => f),
            equals(1400),
            reason: 'The value returned by repository was 1400',
          );

          result = await usecase.expectedBalanceOf(
            month: Date.today().month,
            year: Date.today().year,
          );

          expect(
            result.isSuccess(),
            isTrue,
            reason: 'Repository returned the expected value of this month',
          );

          expect(
            result.fold((s) => s, (f) => f),
            equals(1400),
            reason: 'The value returned by repository was 1400',
          );
        });
      });

      group("when date is after actual date", () {
        final dateAfter = date.add(months: 1);
        group("returns a Fail while fetching", () {
          test("the expected value for the actual month", () async {
            when(() => balanceRepository.getExpectedBalanceOf(
                    month: any(named: 'month'), year: any(named: 'year')))
                .thenAnswer((_) async => Failure(Fail("")));

            final result = await usecase.expectedBalanceOf(
              month: dateAfter.month,
              year: dateAfter.year,
            );

            expect(
              result.isError(),
              isTrue,
              reason:
                  'Must return a fail because an error happened fetching expected balance of actual month',
            );
          });
          test("the sum of expenses", () async {
            when(() => expenseRepository.getSumOfExpensesWithFrequency(any()))
                .thenAnswer((_) async => Failure(Fail("")));

            final result = await usecase.expectedBalanceOf(
              month: dateAfter.month,
              year: dateAfter.year,
            );

            expect(
              result.isError(),
              isTrue,
              reason:
                  'Must return a fail because an error happened fetching sum of expenses',
            );
          });
          test("the sum of incomes", () async {
            when(() => incomeRepository.getSumOfIncomesWithFrequency(any()))
                .thenAnswer((_) async => Failure(Fail("")));

            final result = await usecase.expectedBalanceOf(
              month: dateAfter.month,
              year: dateAfter.year,
            );

            expect(
              result.isError(),
              isTrue,
              reason:
                  'Must return a fail because an error happened fetching sum of incomes',
            );
          });
          test("the sum of invoices in the range", () async {
            when(() => invoiceRepository.getSumOfInvoicesInRange(
                  inferiorLimit: any(named: 'inferiorLimit'),
                  upperLimit: any(named: 'upperLimit'),
                )).thenAnswer((_) async => Failure(Fail("")));

            final result = await usecase.expectedBalanceOf(
              month: dateAfter.month,
              year: dateAfter.year,
            );

            expect(
              result.isError(),
              isTrue,
              reason:
                  'Must return a fail because an error happened fetching sum of invoices in a range',
            );
          });
          test("the sum of installment parcels in a range", () async {
            when(() => installmentRepository.getSumOfInstallmentParcelsInRange(
                  inferiorLimit: any(named: 'inferiorLimit'),
                  upperLimit: any(named: 'upperLimit'),
                )).thenAnswer((_) async => Failure(Fail("")));

            final result = await usecase.expectedBalanceOf(
              month: dateAfter.month,
              year: dateAfter.year,
            );

            expect(
              result.isError(),
              isTrue,
              reason:
                  'Must return a fail because an error happened fetching sum of installment parcels in a range',
            );
          });
        });
        test("calcs the expected balance correctly", () async {
          var result = await usecase.expectedBalanceOf(
            month: dateAfter.month,
            year: dateAfter.year,
          );

          expect(
            result.fold((s) => s, (f) => f),
            equals(966.24),
            reason: 'The calc may have an error, check them',
          );

          final date2MonthsAfter =
              dateAfter.copyWith(month: dateAfter.month + 1);
          final date3MonthsAfter =
              dateAfter.copyWith(month: dateAfter.month + 2);

          when(() => expenseRepository.getSumOfExpensesWithFrequency(any()))
              .thenAnswer((_) async => const Success(100));
          when(() => incomeRepository.getSumOfIncomesWithFrequency(any()))
              .thenAnswer((_) async => const Success(200));

          result = await usecase.expectedBalanceOf(
            month: date2MonthsAfter.month,
            year: date2MonthsAfter.year,
          );

          var expectedResult = (1400 +
                  _calcMonthBalanceOf(
                      date: dateAfter,
                      monthlyValue: 200,
                      weeklyValue: 200,
                      dailyValue: 200) +
                  _calcMonthBalanceOf(
                      date: date2MonthsAfter,
                      monthlyValue: 200,
                      weeklyValue: 200,
                      dailyValue: 200) -
                  _calcMonthBalanceOf(
                      date: dateAfter,
                      monthlyValue: 100,
                      weeklyValue: 100,
                      dailyValue: 100) -
                  _calcMonthBalanceOf(
                      date: date2MonthsAfter,
                      monthlyValue: 100,
                      weeklyValue: 100,
                      dailyValue: 100) -
                  230 -
                  203.76)
              .roundToDecimal();

          expect(
            result.fold((s) => s, (f) => f),
            equals(expectedResult),
            reason:
                'The calc may have an error when calculating for two or more months ahead, check them',
          );

          result = await usecase.expectedBalanceOf(
            month: date3MonthsAfter.month,
            year: date3MonthsAfter.year,
          );

          expectedResult = (expectedResult +
                  _calcMonthBalanceOf(
                      date: date3MonthsAfter,
                      monthlyValue: 200,
                      weeklyValue: 200,
                      dailyValue: 200) -
                  _calcMonthBalanceOf(
                      date: date3MonthsAfter,
                      monthlyValue: 100,
                      weeklyValue: 100,
                      dailyValue: 100))
              .roundToDecimal();

          expect(
            result.fold((s) => s, (f) => f),
            equals(expectedResult),
            reason:
                'The calc may have an error when calculating for two or more months ahead, check them',
          );
        });
      });
    });
    group("Get Final Value Of method", () {
      final dateBefore = Date.today().subtract(months: 3);

      setUp(() {
        when(() => balanceRepository.getFinalBalanceOf(
                month: any(named: 'month'), year: any(named: 'year')))
            .thenAnswer((_) async => const Success(1095.0));
      });
      test("returns a Fail when error happens in repository", () async {
        when(() => balanceRepository.getFinalBalanceOf(
                month: any(named: 'month'), year: any(named: 'year')))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.finalBalanceOf(
          month: dateBefore.month,
          year: dateBefore.year,
        );

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return an error because repository returned an error',
        );
      });
      test("returns the value when no error happens", () async {
        final result = await usecase.finalBalanceOf(
          month: dateBefore.month,
          year: dateBefore.year,
        );

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'Must return a value because no error happens',
        );
        expect(
          result.fold((s) => s, (f) => f),
          equals(1095.0),
          reason: 'Must return the exactly same value returned by repository',
        );
      });
      test("returns DateError when date is actual or later than actual",
          () async {
        final date = Date.today();
        var result = await usecase.finalBalanceOf(
          month: date.month,
          year: date.year,
        );

        expect(
          result.isError(),
          isTrue,
          reason:
              'Must return an error because month and year are the same as actuals',
        );
        expect(
          result.fold((s) => s, (f) => f),
          isA<DateError>(),
          reason: 'The error must be a DateError',
        );

        final dateAfter = date.add(months: 1);
        result = await usecase.finalBalanceOf(
          month: dateAfter.month,
          year: dateAfter.year,
        );

        expect(
          result.isError(),
          isTrue,
          reason:
              'Must return an error because month and year are later than actuals',
        );
        expect(
          result.fold((s) => s, (f) => f),
          isA<DateError>(),
          reason: 'The error must be a DateError',
        );
      });
    });
  });
}

double _calcMonthBalanceOf({
  required Date date,
  required double monthlyValue,
  required double weeklyValue,
  required double dailyValue,
}) =>
    monthlyValue +
    dailyValue * date.totalDaysOfMonth +
    weeklyValue * date.toDateTime().totalWeeks;
