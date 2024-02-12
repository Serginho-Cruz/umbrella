// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:result_dart/result_dart.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/ibalance_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_parcel_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/ipayment_method_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/itransaction_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_type.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice_item.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/transaction.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/date_error_messages.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/generic_messages.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/entities/frequency.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/usecases/imanage_invoice.dart';
import '../../errors/errors.dart';
import '../../errors/invoice_messages.dart';
import '../repositories/iexpense_repository.dart';
import '../repositories/iinvoice_item_repository.dart';
import '../repositories/iinvoice_repository.dart';

class ManageInvoice implements IManageInvoice {
  final IInvoiceRepository invoiceRepository;
  final IInvoiceItemRepository invoiceItemRepository;
  final ITransactionRepository transactionRepository;
  final IPaymentMethodRepository paymentMethodRepository;
  final IExpenseRepository expenseRepository;
  final IExpenseParcelRepository expenseParcelRepository;
  final IBalanceRepository balanceRepository;

  ManageInvoice({
    required this.invoiceRepository,
    required this.invoiceItemRepository,
    required this.transactionRepository,
    required this.paymentMethodRepository,
    required this.expenseRepository,
    required this.expenseParcelRepository,
    required this.balanceRepository,
  });

  @override
  Future<Result<void, Fail>> update({
    required Invoice newInvoice,
    required Invoice oldInvoice,
  }) async {
    if (newInvoice == oldInvoice) return const Success(2);

    if (newInvoice.closingDate.isAfter(newInvoice.dueDate)) {
      return Failure(InvoiceUpdateError(InvoiceMessages.datesError));
    }

    if (newInvoice.totalValue < 0.0) {
      return Failure(InvoiceUpdateError(GenericMessages.invalidNumber));
    }

    if (oldInvoice.totalValue != newInvoice.totalValue) {
      final difference =
          (newInvoice.totalValue - oldInvoice.totalValue).roundToDecimal();

      final expense = Expense.withoutId(
        value: difference,
        name: "Ajuste de Fatura",
        dueDate: Date.today(),
        type: const ExpenseType(id: 1, icon: '', name: ''),
        frequency: Frequency.none,
      );

      final createExpenseResult = await expenseRepository.create(expense);

      if (createExpenseResult.isError()) return createExpenseResult;

      final parcel = _getAdjustParcel(expense: expense, value: difference);

      final createParcelResult = await expenseParcelRepository.create(parcel);

      if (createParcelResult.isError()) return createParcelResult;

      final createItemResult = await invoiceItemRepository.addItemToInvoice(
        invoice: oldInvoice,
        item: InvoiceItem(
          isAdjust: true,
          parcel: parcel,
          paymentDate: Date.today(),
          value: difference,
        ),
      );

      if (createItemResult.isError()) return createItemResult;
    }

    if (newInvoice.dueDate.isMonthAfter(oldInvoice.dueDate) &&
        oldInvoice.dueDate.isOfActualMonth) {
      final incrementExpectedResult =
          await balanceRepository.sumToExpectedBalance(oldInvoice.totalValue);

      if (incrementExpectedResult.isError()) return incrementExpectedResult;
    } else if (oldInvoice.dueDate.isMonthAfter(newInvoice.dueDate) &&
        newInvoice.dueDate.isOfActualMonth) {
      final decrementExpectedResult = await balanceRepository
          .decrementFromExpectedBalance(newInvoice.totalValue);

      if (decrementExpectedResult.isError()) return decrementExpectedResult;
    } else {
      final difference = (newInvoice.totalValue - oldInvoice.totalValue)
          .abs()
          .roundToDecimal();

      if (newInvoice.totalValue > oldInvoice.totalValue) {
        final decrementExpectedBalance =
            await balanceRepository.decrementFromExpectedBalance(difference);

        if (decrementExpectedBalance.isError()) return decrementExpectedBalance;
      } else if (newInvoice.totalValue < oldInvoice.totalValue) {
        final incrementExpectedBalanceResult =
            await balanceRepository.sumToExpectedBalance(difference);

        if (incrementExpectedBalanceResult.isError()) {
          return incrementExpectedBalanceResult;
        }
      }
    }

    if (oldInvoice.paidValue > newInvoice.totalValue) {
      final difference =
          (oldInvoice.paidValue - newInvoice.totalValue).roundToDecimal();

      final transactionResult = await transactionRepository.register(
        Transaction.withoutId(
          isAdjust: true,
          value: difference * -1,
          paymentDate: Date.today(),
          paiyable: oldInvoice,
          paymentMethod: const PaymentMethod(
            id: 1,
            icon: '',
            name: '',
            isCredit: false,
          ),
        ),
      );

      if (transactionResult.isError()) return transactionResult;

      final incrementActualBalance =
          await balanceRepository.sumToActualBalance(difference);

      if (incrementActualBalance.isError()) return incrementActualBalance;
    }

    return invoiceRepository.update(newInvoice);
  }

  @override
  Future<Result<List<Invoice>, Fail>> getAllOf({
    required int month,
    required int year,
  }) async {
    if (month < 1 || month > 12) {
      return Failure(DateError(DateErrorMessages.invalidMonth));
    } else if (year < 2000) {
      return Failure(DateError(DateErrorMessages.invalidYear));
    }

    return invoiceRepository.getAllOf(month: month, year: year);
  }

  @override
  Future<Result<Invoice, Fail>> getActualOfCard(CreditCard card) =>
      invoiceRepository.getActualOfCard(card);

  @override
  Future<Result<List<Invoice>, Fail>> getAllOfCard(CreditCard card) =>
      invoiceRepository.getAllOfCard(card);

  @override
  Future<Result<void, Fail>> reset(Invoice invoice) async {
    final invoiceResetResult = await invoiceRepository.resetInvoice(invoice);

    if (invoiceResetResult.isError()) return invoiceResetResult;

    Map<ExpenseParcel, double> itemValueOfEachParcel = {};

    for (var item in invoice.itens) {
      var parcel = item.parcel.copyWith();

      itemValueOfEachParcel.putIfAbsent(
          parcel.copyWith(
            paidValue: parcel.paidValue - item.value,
            remainingValue: parcel.remainingValue + item.value,
          ),
          () => item.value);
    }

    final updateParcelsResult = await expenseParcelRepository
        .updateParcels(itemValueOfEachParcel.keys.toList());

    if (updateParcelsResult.isError()) return updateParcelsResult;

    final removeValueFromCreditResult = await paymentMethodRepository
        .removeValueFromCreditMethodForAll(itemValueOfEachParcel);

    if (removeValueFromCreditResult.isError()) {
      return removeValueFromCreditResult;
    }

    final invoiceItensDelete =
        await invoiceItemRepository.removeItensFromInvoice(
      invoice: invoice,
      itens: invoice.itens,
    );

    if (invoiceItensDelete.isError()) return invoiceItensDelete;

    if (invoice.paidValue > 0.0) {
      final incrementActualBalanceResut =
          await balanceRepository.sumToActualBalance(invoice.paidValue);

      if (incrementActualBalanceResut.isError()) {
        return incrementActualBalanceResut;
      }
    }

    final actualDate = Date.today();
    final firstDayOfNextMonth = Date(
      year: actualDate.year,
      month: actualDate.month + 1,
      day: 1,
    );

    if (invoice.dueDate.isAfter(firstDayOfNextMonth) ||
        invoice.dueDate.isAtTheSameMonthAs(firstDayOfNextMonth)) {
      final sum = _sumWhere(
        itens: invoice.itens,
        test: (item) => item.parcel.dueDate.isBefore(firstDayOfNextMonth),
      );

      final decrementBalanceResult =
          await balanceRepository.decrementFromExpectedBalance(sum);

      if (decrementBalanceResult.isError()) return decrementBalanceResult;
    } else {
      final sum = _sumWhere(
          itens: invoice.itens,
          test: (item) => !item.parcel.dueDate.isBefore(firstDayOfNextMonth));

      final incrementBalanceResult =
          await balanceRepository.sumToExpectedBalance(sum);

      if (incrementBalanceResult.isError()) return incrementBalanceResult;
    }

    return transactionRepository.deleteAllOf(invoice);
  }

  ExpenseParcel _getAdjustParcel({
    required Expense expense,
    required double value,
  }) =>
      ExpenseParcel.withoutId(
        expense: expense,
        dueDate: Date.today(),
        paidValue: value,
        remainingValue: 0,
        totalValue: value,
        paymentDate: Date.today(),
      );

  double _sumWhere({
    required List<InvoiceItem> itens,
    required bool Function(InvoiceItem) test,
  }) {
    double sum = 0.0;

    for (var item in itens) {
      sum += test(item) ? item.value : 0.0;
    }

    return sum.roundToDecimal();
  }
}
