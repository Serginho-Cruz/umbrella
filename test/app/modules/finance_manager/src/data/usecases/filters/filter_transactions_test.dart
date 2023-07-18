import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/filters/filter_transactions.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/transaction.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/filters/ifilter_transactions.dart';

import '../../../utils/factorys/payment_method_factory.dart';
import '../../../utils/factorys/transaction_type_factory.dart';
import '../../../utils/factorys/transactions_factory.dart';

void main() {
  late IFilterTransactions usecase;
  late List<Transaction> transactions = [];

  setUp(() {
    usecase = FilterTransactions();
    transactions.clear();
    transactions
        .addAll(List.generate(8, (_) => TransactionsFactory.generate()));
  });

  group("Filter Transactions Useacse is Working", () {
    test(
        "by PaymentMethod returns only transactions paiyed with a specific paymentMethod",
        () {
      var paymentMethod = PaymentMethodFactory.generate();
      transactions.addAll(List.generate(
          5, (_) => TransactionsFactory.generate(method: paymentMethod)));

      var filteredTransactions = usecase.byPaymentMethod(
        transactions: transactions,
        paymentMethod: paymentMethod,
      );

      expect(filteredTransactions.length, greaterThan(0));
      for (var transaction in filteredTransactions) {
        expect(transaction.paymentMethod, equals(paymentMethod));
      }
    });
    test("by Type returns only transactions of a specific type", () {
      var type = TransactionTypeFactory.generate();
      transactions.addAll(List.generate(
          5,
          (_) =>
              TransactionsFactory.generateWithType(TransactionType.expense)));

      var filteredTransactions = usecase.byType(
        transactions: transactions,
        type: type,
      );

      bool Function(Paiyable) test = <TransactionType, bool Function(Paiyable)>{
        TransactionType.expense: (p) => p is ExpenseParcel,
        TransactionType.income: (p) => p is IncomeParcel,
        TransactionType.invoice: (p) => p is Invoice,
      }[type]!;

      expect(filteredTransactions.length, greaterThan(0));
      for (var transaction in filteredTransactions) {
        expect(test(transaction.paiyable), equals(true));
      }
    });
    test(
        "by Value returns only transactions with value equal or greater than specified",
        () {
      transactions.addAll(List.generate(
          5, (_) => TransactionsFactory.generate(minValue: 350.0)));

      var filteredTransactions = usecase.byValue(
        transactions: transactions,
        value: 350.0,
      );

      expect(filteredTransactions.length, greaterThan(0));
      for (var transaction in filteredTransactions) {
        expect(transaction.value, greaterThanOrEqualTo(350.0));
      }
    });
    group("Transactions List passed by parameter remains unmodified", () {
      test("In byValue method", () {
        transactions.addAll(List.generate(
            4, (_) => TransactionsFactory.generate(minValue: 300.0)));
        var transactionsBeforeFilter = [...transactions];

        usecase.byValue(transactions: transactions, value: 300);

        expect(transactionsBeforeFilter.length, equals(transactions.length));

        for (int i = 0; i < transactionsBeforeFilter.length; i++) {
          expect(
            transactionsBeforeFilter.elementAt(i),
            equals(transactions.elementAt(i)),
          );
        }
      });
      test("In byPaymentMethod method", () {
        var method = PaymentMethodFactory.generate();
        transactions.addAll(List.generate(
            4, (_) => TransactionsFactory.generate(method: method)));

        var transactionsBeforeFilter = [...transactions];

        usecase.byPaymentMethod(
            transactions: transactions, paymentMethod: method);

        expect(transactionsBeforeFilter.length, equals(transactions.length));

        for (int i = 0; i < transactionsBeforeFilter.length; i++) {
          expect(
            transactionsBeforeFilter.elementAt(i),
            equals(transactions.elementAt(i)),
          );
        }
      });
      test("In byType method", () {
        var type = TransactionTypeFactory.generate();
        transactions.addAll(List.generate(
            4, (_) => TransactionsFactory.generateWithType(type)));
        var transactionsBeforeFilter = [...transactions];

        usecase.byType(transactions: transactions, type: type);

        expect(transactionsBeforeFilter.length, equals(transactions.length));

        for (int i = 0; i < transactionsBeforeFilter.length; i++) {
          expect(
            transactionsBeforeFilter.elementAt(i),
            equals(transactions.elementAt(i)),
          );
        }
      });
    });
  });
}
