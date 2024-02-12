import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/ibalance_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_parcel_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iinvoice_item_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iinvoice_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/ipayment_method_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/itransaction_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/manage_invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice_item.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imanage_invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';

import '../../utils/factorys/credit_card_factory.dart';
import '../../utils/factorys/expense_factory.dart';
import '../../utils/factorys/expense_parcel_factory.dart';
import '../../utils/factorys/invoice_factory.dart';
import '../../utils/factorys/invoice_item_factory.dart';
import '../../utils/factorys/transactions_factory.dart';
import '../repositories/balance_repository_mock.dart';
import '../repositories/expense_parcel_repository_mock.dart';
import '../repositories/expense_repository_mock.dart';
import '../repositories/invoice_item_repository_mock.dart';
import '../repositories/invoice_repository_mock.dart';
import '../repositories/payment_method_repository_mock.dart';
import '../repositories/transaction_repository_mock.dart';

void main() {
  late IInvoiceRepository invoiceRepository;
  late IBalanceRepository balanceRepository;
  late IInvoiceItemRepository invoiceItemRepository;
  late IPaymentMethodRepository paymentMethodRepository;
  late IExpenseRepository expenseRepository;
  late IExpenseParcelRepository expenseParcelRepository;
  late ITransactionRepository transactionRepository;
  late IManageInvoice usecase;

  setUpAll(() {
    registerFallbackValue(InvoiceFactory.generate());
    registerFallbackValue(InvoiceItemFactory.generate());
    registerFallbackValue(
        ExpenseParcelFactory.generate(totalValue: 500.0, paidValue: 500.0));
    registerFallbackValue(CreditCardFactory.generate());
    registerFallbackValue(TransactionsFactory.generate());
    registerFallbackValue(ExpenseFactory.generate());
  });

  setUp(() {
    invoiceRepository = InvoiceRepositoryMock();
    balanceRepository = BalanceRepositoryMock();
    invoiceItemRepository = InvoiceItemRepositoryMock();
    expenseParcelRepository = ExpenseParcelRepositoryMock();
    transactionRepository = TransactionRepositoryMock();
    expenseRepository = ExpenseRepositoryMock();
    paymentMethodRepository = PaymentMethodRepositoryMock();

    usecase = ManageInvoice(
      invoiceRepository: invoiceRepository,
      invoiceItemRepository: invoiceItemRepository,
      transactionRepository: transactionRepository,
      paymentMethodRepository: paymentMethodRepository,
      expenseParcelRepository: expenseParcelRepository,
      expenseRepository: expenseRepository,
      balanceRepository: balanceRepository,
    );
  });

  group("Manage Invoice usecase is Working", () {
    group("update method", () {
      final oldInvoice = InvoiceFactory.generate(
        closingDate: Date.today().copyWith(day: 10),
        dueDate: Date.today().copyWith(day: 20),
        paidValue: 0.0,
        totalValue: 500.0,
      );
      setUp(() {
        when(() => invoiceRepository.update(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => invoiceItemRepository.addItemToInvoice(
                invoice: any(named: 'invoice'), item: any(named: 'item')))
            .thenAnswer((_) async => const Success(2));
        when(() => expenseRepository.create(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => expenseParcelRepository.create(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => balanceRepository.decrementFromExpectedBalance(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => balanceRepository.sumToExpectedBalance(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => balanceRepository.sumToActualBalance(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => transactionRepository.register(any()))
            .thenAnswer((_) async => const Success(2));
      });

      group("returns InvoiceUpdateError when", () {
        test("new close date is after new due date", () async {
          final newInvoice = InvoiceFactory.generate(
              dueDate: Date(year: 2023, month: 2, day: 3),
              closingDate: Date(year: 2023, month: 3, day: 15));

          final result = await usecase.update(
            newInvoice: newInvoice,
            oldInvoice: oldInvoice,
          );

          expect(
            result.isError(),
            isTrue,
            reason:
                'Must return error because new close date is after new due date',
          );

          expect(
            result.fold((s) {}, (f) => f),
            isA<InvoiceUpdateError>(),
            reason: 'The error must be an InvoiceUpdateError instance',
          );
        });
        test("new value is negative", () async {
          final newInvoice = InvoiceFactory.generate(
            closingDate: Date(year: 2023, month: 4, day: 5),
            dueDate: Date(year: 2023, month: 4, day: 15),
            totalValue: -1.87,
          );

          final result = await usecase.update(
            newInvoice: newInvoice,
            oldInvoice: oldInvoice,
          );

          expect(
            result.isError(),
            isTrue,
            reason: 'Must return error because new total value is negative',
          );

          expect(
            result.fold((s) {}, (f) => f),
            isA<InvoiceUpdateError>(),
            reason: 'The error must be an InvoiceUpdateError instance',
          );
        });
      });

      test("update invoice when no error happens", () async {
        await usecase.update(
          newInvoice: InvoiceFactory.generate(
            closingDate: Date.today().copyWith(day: 15),
            dueDate: Date.today().copyWith(day: 22),
          ),
          oldInvoice: oldInvoice,
        );

        verify(() => invoiceRepository.update(any()));
      });
      group("when total value is changed", () {
        final newInvoice = oldInvoice.copyWith(totalValue: 600.0);

        group("registers an expense", () {
          test("with frequency none", () async {
            await usecase.update(
                newInvoice: newInvoice, oldInvoice: oldInvoice);

            Expense expense =
                verify(() => expenseRepository.create(captureAny()))
                    .captured
                    .first;

            expect(
              expense.frequency,
              equals(Frequency.none),
              reason: 'The expense registered must be non frequent',
            );
          });
          test("with negative value when new total value is less than old",
              () async {
            final newInvoiceLessThanOld =
                newInvoice.copyWith(totalValue: 400.0);

            await usecase.update(
              newInvoice: newInvoiceLessThanOld,
              oldInvoice: oldInvoice,
            );

            Expense expense =
                verify(() => expenseRepository.create(captureAny()))
                    .captured
                    .first;

            expect(
              expense.value,
              equals(-100.0),
              reason: 'The expense value must be -100.0',
            );
          });
          test("with positive value when new total value is greater than old",
              () async {
            await usecase.update(
              newInvoice: newInvoice,
              oldInvoice: oldInvoice,
            );

            Expense expense =
                verify(() => expenseRepository.create(captureAny()))
                    .captured
                    .first;

            expect(
              expense.value,
              equals(100.0),
              reason: 'The expense value must be 100.0',
            );
          });
        });
        test("returns error when an error happens creating expense", () async {
          when(() => expenseRepository.create(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.update(
            newInvoice: newInvoice,
            oldInvoice: oldInvoice,
          );

          expect(
            result.isError(),
            isTrue,
            reason:
                'Must return an error because repository failed creating expense',
          );
        });
        group("registers an expense parcel", () {
          test("with the same expense created by expense repository", () async {
            await usecase.update(
              newInvoice: newInvoice,
              oldInvoice: oldInvoice,
            );

            Expense expenseCreated =
                verify(() => expenseRepository.create(captureAny()))
                    .captured
                    .first;

            ExpenseParcel expenseParcel =
                verify(() => expenseParcelRepository.create(captureAny()))
                    .captured
                    .first;

            expect(
              expenseCreated,
              equals(expenseParcel.expense),
              reason:
                  'The expense of expense parcel must be the same created by expense repository',
            );
          });
          test(
              "with negative total value when new invoice's total value is less than old",
              () async {
            final newInvoiceLessThanOld =
                newInvoice.copyWith(totalValue: 400.0);

            await usecase.update(
              newInvoice: newInvoiceLessThanOld,
              oldInvoice: oldInvoice,
            );

            ExpenseParcel parcel =
                verify(() => expenseParcelRepository.create(captureAny()))
                    .captured
                    .first;

            expect(
              parcel.totalValue,
              equals(-100.0),
              reason: "Parcel's total value must be -100.0",
            );
          });
          test(
              "with positive total value when new invoice's total value is greater than old",
              () async {
            await usecase.update(
              newInvoice: newInvoice,
              oldInvoice: oldInvoice,
            );

            ExpenseParcel parcel =
                verify(() => expenseParcelRepository.create(captureAny()))
                    .captured
                    .first;

            expect(
              parcel.totalValue,
              equals(100.0),
              reason: "Parcel's total value must be 100.0",
            );
          });
        });
        test("returns error when an error happens registering expense parcel",
            () async {
          when(() => expenseParcelRepository.create(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.update(
            newInvoice: newInvoice,
            oldInvoice: oldInvoice,
          );

          expect(
            result.isError(),
            isTrue,
            reason:
                'Must return error because repository failed registering expense parcel',
          );
        });
        group("add an item to invoice", () {
          test(
              "item's parcel must be the same created by expense parcel repository",
              () async {
            await usecase.update(
              newInvoice: newInvoice,
              oldInvoice: oldInvoice,
            );

            ExpenseParcel parcelCreated =
                verify(() => expenseParcelRepository.create(captureAny()))
                    .captured
                    .first;

            InvoiceItem item = verify(() =>
                invoiceItemRepository.addItemToInvoice(
                    invoice: any(named: 'invoice'),
                    item: captureAny(named: 'item'))).captured.first;

            expect(
              parcelCreated,
              equals(item.parcel),
              reason:
                  'The parcel of invoice item created must be the same created by expense parcel repository',
            );
          });
          test(
              "with negative value when new invoice's total value is less than old",
              () async {
            final newInvoiceLessThanOld =
                newInvoice.copyWith(totalValue: 400.0);

            await usecase.update(
              newInvoice: newInvoiceLessThanOld,
              oldInvoice: oldInvoice,
            );

            InvoiceItem item = verify(() =>
                invoiceItemRepository.addItemToInvoice(
                    invoice: any(named: 'invoice'),
                    item: captureAny(named: 'item'))).captured.first;

            expect(
              item.value,
              equals(-100.0),
              reason: "Item's value must be -100.0",
            );
          });
          test(
              "with positive value when new invoice's total value is greater than old",
              () async {
            await usecase.update(
              newInvoice: newInvoice,
              oldInvoice: oldInvoice,
            );

            InvoiceItem item = verify(() =>
                invoiceItemRepository.addItemToInvoice(
                    invoice: any(named: 'invoice'),
                    item: captureAny(named: 'item'))).captured.first;

            expect(
              item.value,
              equals(100.0),
              reason: "Item's value must be -100.0",
            );
          });
          test("with adjust marker", () async {
            await usecase.update(
              newInvoice: newInvoice,
              oldInvoice: oldInvoice,
            );

            InvoiceItem item = verify(() =>
                invoiceItemRepository.addItemToInvoice(
                    invoice: any(named: 'invoice'),
                    item: captureAny(named: 'item'))).captured.first;

            expect(
              item.isAdjust,
              isTrue,
              reason: 'The invoice item isAdjust parameter must be true',
            );
          });
        });
        test("returns error when an error happens adding an item to invoice",
            () async {
          when(() => invoiceItemRepository.addItemToInvoice(
                  invoice: any(named: 'invoice'), item: any(named: 'item')))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.update(
            newInvoice: newInvoice,
            oldInvoice: oldInvoice,
          );

          expect(
            result.isError(),
            isTrue,
            reason:
                'Must return an error because repository failed adding an item to invoice updated',
          );

          verify(() => invoiceItemRepository.addItemToInvoice(
              invoice: any(named: 'invoice'), item: any(named: 'item')));
        });
      });

      group("when old due date was in actual month and new is in next month",
          () {
        final newInvoice = oldInvoice.copyWith(
            dueDate: oldInvoice.dueDate
                .copyWith(month: oldInvoice.dueDate.month + 1));

        test("increments expected balance", () async {
          await usecase.update(
            newInvoice: newInvoice,
            oldInvoice: oldInvoice,
          );

          verify(() => balanceRepository.sumToExpectedBalance(any()));
        });
        test("increments expected balance with the correct value", () async {
          await usecase.update(
            newInvoice: newInvoice,
            oldInvoice: oldInvoice,
          );

          double valueIncremented =
              verify(() => balanceRepository.sumToExpectedBalance(captureAny()))
                  .captured
                  .first;

          expect(
            valueIncremented,
            equals(oldInvoice.totalValue),
            reason:
                "The value incremented must be the same of old invoice's total value",
          );
        });
        test(
            "returns error when an error happens incrementing expected balance",
            () async {
          when(() => balanceRepository.sumToExpectedBalance(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.update(
            newInvoice: newInvoice,
            oldInvoice: oldInvoice,
          );

          expect(
            result.isError(),
            isTrue,
            reason:
                'Must return error because an error happened incrementing expected balance',
          );

          verify(() => balanceRepository.sumToExpectedBalance(any()));
        });
      });
      group("when old due date was in next month and new is in actual month",
          () {
        final newInvoice = oldInvoice.copyWith(dueDate: oldInvoice.dueDate);
        final oldInvoiceNextMonth = oldInvoice.copyWith(
            dueDate: oldInvoice.dueDate
                .copyWith(month: oldInvoice.dueDate.month + 1));

        test("decrements expected balance", () async {
          await usecase.update(
            newInvoice: newInvoice,
            oldInvoice: oldInvoiceNextMonth,
          );

          verify(() => balanceRepository.decrementFromExpectedBalance(any()));
        });
        test("decrements expected balance with the correct value", () async {
          await usecase.update(
            newInvoice: newInvoice,
            oldInvoice: oldInvoiceNextMonth,
          );

          double valueDecremented = verify(() =>
                  balanceRepository.decrementFromExpectedBalance(captureAny()))
              .captured
              .first;

          expect(
            valueDecremented,
            equals(newInvoice.totalValue),
            reason:
                "The value decremented must be the same of new invoice's total value",
          );
        });
        test(
            "returns error when an error happens decrementing expected balance",
            () async {
          when(() => balanceRepository.decrementFromExpectedBalance(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.update(
            newInvoice: newInvoice,
            oldInvoice: oldInvoiceNextMonth,
          );

          expect(
            result.isError(),
            isTrue,
            reason:
                'Must return error because an error happened decrementing expected balance',
          );

          verify(() => balanceRepository.decrementFromExpectedBalance(any()));
        });
      });
      group("when old due date and new due date is of actual month", () {
        final newInvoice = oldInvoice.copyWith(
          dueDate: oldInvoice.dueDate.copyWith(day: 25),
          totalValue: 600.0,
        );

        group("and new total value is greater than old's", () {
          test("decrements expected balance by the correct value", () async {
            await usecase.update(
              newInvoice: newInvoice,
              oldInvoice: oldInvoice,
            );

            double valueDecremented = verify(() => balanceRepository
                .decrementFromExpectedBalance(captureAny())).captured.first;

            const double valueExpected = 100.0;

            expect(
              valueDecremented,
              equals(valueExpected),
              reason: 'The value decremented must be 100.0',
            );
          });
          test(
              "returns error when an error happens decrementing expected balance",
              () async {
            when(() => balanceRepository.decrementFromExpectedBalance(any()))
                .thenAnswer((_) async => Failure(Fail("")));

            final result = await usecase.update(
              newInvoice: newInvoice,
              oldInvoice: oldInvoice,
            );

            expect(
              result.isError(),
              isTrue,
              reason:
                  'Must return error because an error happened in repository decrementing expected balance',
            );
          });
        });
        group("and new total value is less than old's", () {
          final newInvoiceValueLess = newInvoice.copyWith(totalValue: 400.0);
          test("increments expected balance by the correct value", () async {
            await usecase.update(
              newInvoice: newInvoiceValueLess,
              oldInvoice: oldInvoice,
            );

            double valueIncremented = verify(
                    () => balanceRepository.sumToExpectedBalance(captureAny()))
                .captured
                .first;

            const double valueExpected = 100.0;

            expect(
              valueIncremented,
              equals(valueExpected),
              reason: 'The value incremented must be 100.0',
            );
          });
          test(
              "returns error when an error happens incrementing expected balance",
              () async {
            when(() => balanceRepository.sumToExpectedBalance(any()))
                .thenAnswer((_) async => Failure(Fail("")));

            final result = await usecase.update(
              newInvoice: newInvoiceValueLess,
              oldInvoice: oldInvoice,
            );

            expect(
              result.isError(),
              isTrue,
              reason:
                  'Must return error because an error happened in repository incrementing expected balance',
            );

            verify(() => balanceRepository.sumToExpectedBalance(any()));
          });
        });
      });
      group("when old paid value is greater than new total value", () {
        final oldPaidInvoice =
            oldInvoice.copyWith(paidValue: oldInvoice.totalValue);

        final newInvoice = oldInvoice.copyWith(totalValue: 350.00);

        test("registers a transaction", () async {
          await usecase.update(
            newInvoice: newInvoice,
            oldInvoice: oldPaidInvoice,
          );

          verify(() => transactionRepository.register(any()));
        });

        test("returns error when registering a transaction fails", () async {
          when(() => transactionRepository.register(any()))
              .thenAnswer((_) async => Failure(Fail("")));
          final result = await usecase.update(
            newInvoice: newInvoice,
            oldInvoice: oldPaidInvoice,
          );

          expect(
            result.isError(),
            isTrue,
            reason:
                'Must return error because repository failed registering a transaction',
          );
          verify(() => transactionRepository.register(any()));
        });
        test("increments actual balance", () async {
          await usecase.update(
            newInvoice: newInvoice,
            oldInvoice: oldPaidInvoice,
          );

          verify(() => balanceRepository.sumToActualBalance(any()));
        });
        test("returns error when incrementing actual balance fails", () async {
          when(() => balanceRepository.sumToActualBalance(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.update(
            newInvoice: newInvoice,
            oldInvoice: oldPaidInvoice,
          );

          expect(
            result.isError(),
            isTrue,
            reason:
                'Must return error because repository failed incrementing actual balance',
          );
          verify(() => balanceRepository.sumToActualBalance(any()));
        });
      });
    });
    group("get all of method", () {
      setUp(() {
        when(() => invoiceRepository.getAllOf(
                month: any(named: 'month'), year: any(named: 'year')))
            .thenAnswer((_) async =>
                Success(List.generate(4, (_) => InvoiceFactory.generate())));
      });

      test("returns DateError when month or year is invalid", () async {
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
        result = await usecase.getAllOf(month: 4, year: 1989);

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

        verifyNever(() => invoiceRepository.getAllOf(
            month: any(named: 'month'), year: any(named: 'year')));
      });
      test("returns a fail when an error happens in repository", () async {
        when(() => invoiceRepository.getAllOf(
                month: any(named: 'month'), year: any(named: 'year')))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.getAllOf(month: 2, year: 2023);

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return an error because repository returned error',
        );
        verify(() => invoiceRepository.getAllOf(
            month: any(named: 'month'), year: any(named: 'year')));
      });
      test("returns an invoices list when no error happens", () async {
        final result = await usecase.getAllOf(month: 2, year: 2023);

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'Must return success because no errors happened',
        );

        verify(() => invoiceRepository.getAllOf(
            month: any(named: 'month'), year: any(named: 'year')));
      });
    });
    group("get actual of card method", () {
      setUp(() {
        when(() => invoiceRepository.getActualOfCard(any()))
            .thenAnswer((_) async => Success(InvoiceFactory.generate()));
      });

      test("returns error when an error happens in repository", () async {
        when(() => invoiceRepository.getActualOfCard(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        final result =
            await usecase.getActualOfCard(CreditCardFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return error because repository returned error',
        );

        verify(() => invoiceRepository.getActualOfCard(any()));
      });
      test("returns success when no error happens", () async {
        final result =
            await usecase.getActualOfCard(CreditCardFactory.generate());

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'No errors happened, must return success',
        );

        verify(() => invoiceRepository.getActualOfCard(any()));
      });

      test("returns success when no error happens", () async {
        final card = CreditCardFactory.generate();
        await usecase.getActualOfCard(card);

        verify(() => invoiceRepository.getActualOfCard(card));
      });
    });
    group("get all of card method", () {
      setUp(() {
        when(() => invoiceRepository.getAllOfCard(any())).thenAnswer(
            (_) async =>
                Success(List.generate(4, (_) => InvoiceFactory.generate())));
      });
      test("returns error when an error happens in repository", () async {
        when(() => invoiceRepository.getAllOfCard(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.getAllOfCard(CreditCardFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return error because repository returned error',
        );

        verify(() => invoiceRepository.getAllOfCard(any()));
      });
      test("returns success when no error happens", () async {
        final result = await usecase.getAllOfCard(CreditCardFactory.generate());

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'No errors happened, must return success',
        );

        verify(() => invoiceRepository.getAllOfCard(any()));
      });

      test("returns success when no error happens", () async {
        final card = CreditCardFactory.generate();
        await usecase.getAllOfCard(card);

        verify(() => invoiceRepository.getAllOfCard(card));
      });
    });
    group("reset method", () {
      setUp(() {
        when(() => invoiceRepository.resetInvoice(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => invoiceItemRepository.removeItensFromInvoice(
                itens: any(named: 'itens'), invoice: any(named: 'invoice')))
            .thenAnswer((_) async => const Success(2));
        when(() => expenseParcelRepository.updateParcels(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => paymentMethodRepository.removeValueFromCreditMethodForAll(
            any())).thenAnswer((_) async => const Success(2));
        when(() => balanceRepository.decrementFromExpectedBalance(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => balanceRepository.sumToExpectedBalance(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => balanceRepository.sumToActualBalance(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => transactionRepository.deleteAllOf(any()))
            .thenAnswer((_) async => const Success(2));
      });
      test("resets the invoice passed", () async {
        final invoice = InvoiceFactory.generate();
        await usecase.reset(invoice);

        verify(() => invoiceRepository.resetInvoice(invoice));
      });
      test("returns error when reseting invoice fails", () async {
        when(() => invoiceRepository.resetInvoice(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.reset(InvoiceFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason:
              'Must return error because repository failed reseting invoice',
        );

        verify(() => invoiceRepository.resetInvoice(any()));
      });
      test("removes all invoice itens from invoice passed", () async {
        final invoice = InvoiceFactory.generate();
        await usecase.reset(invoice);

        verify(() => invoiceItemRepository.removeItensFromInvoice(
              itens: invoice.itens,
              invoice: invoice,
            ));
      });
      test("returns error when removing all invoice itens fails", () async {
        when(() => invoiceItemRepository.removeItensFromInvoice(
                itens: any(named: 'itens'), invoice: any(named: 'invoice')))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.reset(InvoiceFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason:
              'Must return error because repository failed removing all itens from invoice',
        );

        verify(() => invoiceItemRepository.removeItensFromInvoice(
            itens: any(named: 'itens'), invoice: any(named: 'invoice')));
      });
      test("updates all parcels of invoice itens", () async {
        await usecase.reset(InvoiceFactory.generate());

        verify(() => expenseParcelRepository.updateParcels(any()));
      });
      test("returns error when updating all parcels of invoice itens fails",
          () async {
        when(() => expenseParcelRepository.updateParcels(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.reset(InvoiceFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason:
              'Must return error because repository failed updating parcels of invoice itens',
        );

        verify(() => expenseParcelRepository.updateParcels(any()));
      });
      test("removes invoice item's value from credit method of all parcels",
          () async {
        await usecase.reset(InvoiceFactory.generate());

        verify(() =>
            paymentMethodRepository.removeValueFromCreditMethodForAll(any()));
      });
      test(
          "returns error when removing invoice item's value from credit method of all parcels fails",
          () async {
        when(() => paymentMethodRepository.removeValueFromCreditMethodForAll(
            any())).thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.reset(InvoiceFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason:
              'Must return error because repository failed removing value from credit method of all parcels',
        );

        verify(() =>
            paymentMethodRepository.removeValueFromCreditMethodForAll(any()));
      });
      test("The map passed to repository contains the correct values",
          () async {
        final invoice = InvoiceFactory.generate();
        await usecase.reset(invoice);

        Map<ExpenseParcel, double> mapPassed = verify(() =>
            paymentMethodRepository.removeValueFromCreditMethodForAll(
                captureAny())).captured.first;

        expect(
          mapPassed.length,
          equals(invoice.itens.length),
          reason: 'The map passed must have the length of invoice itens',
        );

        mapPassed.forEach((parcel, value) {
          var invoiceItem =
              invoice.itens.firstWhere((i) => i.parcel.id == parcel.id);

          expect(
            invoiceItem.value,
            equals(value),
            reason:
                'The value of parcel with id ${parcel.id} is $value, but must be ${invoiceItem.value}',
          );
        });
      });
      test("deletes all transactions of invoice passed", () async {
        final invoice = InvoiceFactory.generate();
        await usecase.reset(invoice);

        Invoice invoicePassed =
            verify(() => transactionRepository.deleteAllOf(captureAny()))
                .captured
                .first;

        expect(
          invoicePassed.id,
          equals(invoice.id),
          reason:
              'Invoice passed to repository must have the same id of invoice passed to usecase',
        );
      });
      test("returns error when repository fails deleting transactions",
          () async {
        when(() => transactionRepository.deleteAllOf(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.reset(InvoiceFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason:
              'Must return error because repository failed deleting transactions',
        );
      });
      group("if invoice's due date is in actual month", () {
        final invoice = InvoiceFactory.generate(
            dueDate: Date.today().copyWith(day: 25),
            closingDate: Date.today().copyWith(day: 14));

        test("increments the expected balance", () async {
          await usecase.reset(invoice);

          verify(() => balanceRepository.sumToExpectedBalance(any()));
        });

        test("increments expected balance by the correct value", () async {
          await usecase.reset(invoice);

          double valuePassed =
              verify(() => balanceRepository.sumToExpectedBalance(captureAny()))
                  .captured
                  .first;

          final actualMonth = invoice.dueDate;
          final nextMonth = Date(
            year: actualMonth.year,
            month: actualMonth.month + 1,
            day: 1,
          );

          double expectedValue = invoice.itens
              .where((item) =>
                  item.parcel.dueDate.isAfter(nextMonth) ||
                  item.parcel.dueDate.isAtTheSameMonthAs(nextMonth))
              .fold(0.0, (v, item) => v + item.value)
              .roundToDecimal();

          expect(
            valuePassed,
            equals(expectedValue),
            reason:
                'The sum is incorrect, probably because parcels of actual month and past months were included in sum',
          );
        });
        test("returns fail when incrementing expected balance fails", () async {
          when(() => balanceRepository.sumToExpectedBalance(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.reset(invoice);

          expect(
            result.isError(),
            isTrue,
            reason:
                'Must return error because repository failed updating expected balance',
          );

          verify(() => balanceRepository.sumToExpectedBalance(any()));
        });
      });
      group("if invoice's due date is in next month", () {
        final now = Date.today();
        final invoice = InvoiceFactory.generate(
            dueDate: Date(year: now.year, month: now.month + 1, day: 14),
            closingDate: Date(year: now.year, month: now.month + 1, day: 4));

        test("decrements the expected balance", () async {
          await usecase.reset(invoice);

          verify(() => balanceRepository.decrementFromExpectedBalance(any()));
        });

        test("decrements expected balance by the correct value", () async {
          await usecase.reset(invoice);

          double valuePassed = verify(() =>
                  balanceRepository.decrementFromExpectedBalance(captureAny()))
              .captured
              .first;

          double expectedValue = invoice.itens
              .where((item) => item.parcel.dueDate.isBefore(invoice.dueDate))
              .fold(0.0, (v, item) => v + item.value)
              .roundToDecimal();

          expect(
            valuePassed,
            equals(expectedValue),
            reason:
                'The sum is incorrect, probably because parcels of next month was included in sum',
          );
        });
        test("returns fail when decrementing expected balance fails", () async {
          when(() => balanceRepository.decrementFromExpectedBalance(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.reset(invoice);

          expect(
            result.isError(),
            isTrue,
            reason:
                'Must return error because repository failed updating expected balance',
          );

          verify(() => balanceRepository.decrementFromExpectedBalance(any()));
        });
      });
      group("if invoice was paid", () {
        final invoice = InvoiceFactory.generate(paidValue: 500.0);

        test("increment actual balance", () async {
          await usecase.reset(invoice);

          verify(() => balanceRepository.sumToActualBalance(any()));
        });

        test("increment actual balance by the correct value", () async {
          await usecase.reset(invoice);

          double valuePassed =
              verify(() => balanceRepository.sumToActualBalance(captureAny()))
                  .captured
                  .first;

          expect(
            valuePassed,
            equals(500.0),
            reason: "The value passed must be the invoice's paidValue",
          );
        });
        test("returns error if increment actual balance fails", () async {
          when(() => balanceRepository.sumToActualBalance(any()))
              .thenAnswer((_) async => Failure(Fail("")));

          final result = await usecase.reset(invoice);

          expect(
            result.isError(),
            isTrue,
            reason:
                'Must return error because repsoitory failed updating actual balance',
          );
        });
      });
    });
  });
}
