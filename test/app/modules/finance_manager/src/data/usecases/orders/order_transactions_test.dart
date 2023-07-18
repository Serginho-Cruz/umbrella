import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/orders/order_transactions.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/transaction.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/orders/iorder_transactions.dart';

import '../../../utils/factorys/transactions_factory.dart';

void main() {
  late IOrderTransactions usecase;
  late List<Transaction> transactions = [];

  setUp(() {
    usecase = OrderTransactions();
    transactions.clear();
    transactions
        .addAll(List.generate(8, (_) => TransactionsFactory.generate()));
  });

  group("Order Transactions Usecase is Working", () {
    group("by value orders by transaction's value and when", () {
      test("isCrescent parameter is true returns in crescent order", () {
        final orderedList = usecase.byValue(
          transactions: transactions,
          isCrescent: true,
        );

        expect(orderedList.length, equals(transactions.length));

        var lastOneValue = orderedList.first.value;
        for (var transaction in orderedList..removeAt(0)) {
          expect(lastOneValue, lessThanOrEqualTo(transaction.value));
          lastOneValue = transaction.value;
        }
      });
      test("isCrescent parameter is false returns in decrescent order", () {
        final orderedList = usecase.byValue(
          transactions: transactions,
          isCrescent: false,
        );

        expect(orderedList.length, equals(transactions.length));

        var lastOneValue = orderedList.first.value;
        for (var transaction in orderedList..removeAt(0)) {
          expect(lastOneValue, greaterThanOrEqualTo(transaction.value));
          lastOneValue = transaction.value;
        }
      });
    });

    group("by payment date orders by transaction's payment date date and when",
        () {
      test("isCrescent parameter is true returns in crescent order", () {
        final orderedList = usecase.byPaymentDate(
          transactions: transactions,
          isCrescent: true,
        );

        expect(orderedList.length, equals(transactions.length));

        var lastOnePaymentDate = orderedList.first.paymentDate;
        for (var transaction in orderedList..removeAt(0)) {
          expect(lastOnePaymentDate.isBefore(transaction.paymentDate), isTrue);
          lastOnePaymentDate = transaction.paymentDate;
        }
      });
      test("isCrescent parameter is false returns in decrescent order", () {
        final orderedList = usecase.byPaymentDate(
          transactions: transactions,
          isCrescent: false,
        );

        expect(orderedList.length, equals(transactions.length));

        var lastOnePaymentDate = orderedList.first.paymentDate;
        for (var transaction in orderedList..removeAt(0)) {
          expect(lastOnePaymentDate.isAfter(transaction.paymentDate), isTrue);
          lastOnePaymentDate = transaction.paymentDate;
        }
      });
    });
    test("by ID orders by transaction's ID in crescent order", () {
      final orderedList = usecase.byID(transactions);

      expect(orderedList.length, equals(transactions.length));

      var lastOneID = orderedList.first.id;
      for (var transaction in orderedList..removeAt(0)) {
        expect(lastOneID.compareTo(transaction.id), lessThanOrEqualTo(0));
        lastOneID = transaction.id;
      }
    });
    test("revert order revert transactions order in the list", () {
      final orderedList = usecase.revertOrder(transactions);

      expect(orderedList.length, equals(transactions.length));

      int i = 0, j = orderedList.length - 1;
      while (i < orderedList.length) {
        expect(orderedList.elementAt(i), equals(transactions.elementAt(j)));
        i++;
        j--;
      }
    });
    group("Transactions List passed by parameter remains unmodified", () {
      test("In byValue method", () {
        var transactionsBeforeOrder = [...transactions];

        usecase.byValue(transactions: transactions, isCrescent: true);

        expect(transactionsBeforeOrder.length, equals(transactions.length));

        for (int i = 0; i < transactionsBeforeOrder.length; i++) {
          expect(
            transactionsBeforeOrder.elementAt(i),
            equals(transactions.elementAt(i)),
          );
        }

        usecase.byValue(transactions: transactions, isCrescent: false);

        expect(transactionsBeforeOrder.length, equals(transactions.length));
        for (int i = 0; i < transactionsBeforeOrder.length; i++) {
          expect(
            transactionsBeforeOrder.elementAt(i),
            equals(transactions.elementAt(i)),
          );
        }
      });
      test("In byPaymentDate method", () {
        var transactionsBeforeOrder = [...transactions];

        usecase.byPaymentDate(transactions: transactions, isCrescent: true);

        expect(transactionsBeforeOrder.length, equals(transactions.length));

        for (int i = 0; i < transactionsBeforeOrder.length; i++) {
          expect(
            transactionsBeforeOrder.elementAt(i),
            equals(transactions.elementAt(i)),
          );
        }

        usecase.byPaymentDate(transactions: transactions, isCrescent: false);

        expect(transactionsBeforeOrder.length, equals(transactions.length));
        for (int i = 0; i < transactionsBeforeOrder.length; i++) {
          expect(
            transactionsBeforeOrder.elementAt(i),
            equals(transactions.elementAt(i)),
          );
        }
      });
      test("In byID method", () {
        var transactionsBeforeOrder = [...transactions];

        usecase.byID(transactions);

        expect(transactionsBeforeOrder.length, equals(transactions.length));

        for (int i = 0; i < transactionsBeforeOrder.length; i++) {
          expect(
            transactionsBeforeOrder.elementAt(i),
            equals(transactions.elementAt(i)),
          );
        }
      });
      test("In revertOrder method", () {
        var transactionsBeforeOrder = [...transactions];

        usecase.revertOrder(transactions);

        expect(transactionsBeforeOrder.length, equals(transactions.length));

        for (int i = 0; i < transactionsBeforeOrder.length; i++) {
          expect(
            transactionsBeforeOrder.elementAt(i),
            equals(transactions.elementAt(i)),
          );
        }
      });
    });
  });
}
