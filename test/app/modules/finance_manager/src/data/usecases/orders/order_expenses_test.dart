import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/orders/order_expenses.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/orders/iorder_expenses.dart';

import '../../../utils/factorys/expense_factory.dart';

void main() {
  late IOrderExpenses usecase;
  late List<Expense> expenses = [];

  setUp(() {
    usecase = OrderExpenses();
    expenses.clear();
    expenses.addAll(List.generate(8, (_) => ExpenseFactory.generate()));
  });

  group("Order Expenses Usecase is Working", () {
    group("by value orders by expense's total value and when", () {
      test("isCrescent parameter is true returns in crescent order", () {
        final orderedList =
            usecase.byValue(expenses: expenses, isCrescent: true);

        expect(orderedList.length, equals(expenses.length));

        var lastOneValue = orderedList.first.totalValue;
        for (var expense in orderedList..removeAt(0)) {
          expect(lastOneValue, lessThanOrEqualTo(expense.totalValue));
          lastOneValue = expense.totalValue;
        }
      });
      test("isCrescent parameter is false returns in decrescent order", () {
        final orderedList =
            usecase.byValue(expenses: expenses, isCrescent: false);

        expect(orderedList.length, equals(expenses.length));

        var lastOneValue = orderedList.first.totalValue;
        for (var expense in orderedList..removeAt(0)) {
          expect(lastOneValue, greaterThanOrEqualTo(expense.totalValue));
          lastOneValue = expense.totalValue;
        }
      });
    });
    group("by name orders by expense's expense name and when", () {
      test("isCrescent parameter is true returns in crescent order", () {
        final orderedList =
            usecase.byName(expenses: expenses, isAlphabetic: true);

        expect(orderedList.length, equals(expenses.length));

        var lastOneName = orderedList.first.name;
        for (var expense in orderedList..removeAt(0)) {
          expect(
            lastOneName.compareTo(expense.name),
            lessThanOrEqualTo(0),
          );
          lastOneName = expense.name;
        }
      });
      test("isCrescent parameter is false returns in decrescent order", () {
        final orderedList =
            usecase.byName(expenses: expenses, isAlphabetic: false);

        expect(orderedList.length, equals(expenses.length));

        var lastOneName = orderedList.first.name;
        for (var expense in orderedList..removeAt(0)) {
          expect(
            lastOneName.compareTo(expense.name),
            greaterThanOrEqualTo(0),
          );
          lastOneName = expense.name;
        }
      });
    });
    group("by due date orders by expense's due date and when", () {
      test("isCrescent parameter is true returns in crescent order", () {
        final orderedList =
            usecase.byDueDate(expenses: expenses, isCrescent: true);

        expect(orderedList.length, equals(expenses.length));

        var lastOneDueDate = orderedList.first.dueDate;
        for (var expense in orderedList..removeAt(0)) {
          expect(lastOneDueDate.isBefore(expense.dueDate), isTrue);
          lastOneDueDate = expense.dueDate;
        }
      });
      test("isCrescent parameter is false returns in decrescent order", () {
        final orderedList =
            usecase.byDueDate(expenses: expenses, isCrescent: false);

        expect(orderedList.length, equals(expenses.length));

        var lastOneDueDate = orderedList.first.dueDate;
        for (var expense in orderedList..removeAt(0)) {
          expect(lastOneDueDate.isAfter(expense.dueDate), isTrue);
          lastOneDueDate = expense.dueDate;
        }
      });
    });

    test("revert order revert expenses order in the list", () {
      final orderedList = usecase.revertOrder(expenses);

      expect(orderedList.length, equals(expenses.length));

      int i = 0, j = orderedList.length - 1;
      while (i < orderedList.length) {
        expect(orderedList.elementAt(i), equals(expenses.elementAt(j)));
        i++;
        j--;
      }
    });
    group("expenses List passed by parameter remains unmodified", () {
      test("In byValue method", () {
        var expensesBeforeOrder = [...expenses];

        usecase.byValue(expenses: expenses, isCrescent: true);

        expect(expensesBeforeOrder.length, equals(expenses.length));

        for (int i = 0; i < expensesBeforeOrder.length; i++) {
          expect(
            expensesBeforeOrder.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }

        usecase.byValue(expenses: expenses, isCrescent: false);

        expect(expensesBeforeOrder.length, equals(expenses.length));
        for (int i = 0; i < expensesBeforeOrder.length; i++) {
          expect(
            expensesBeforeOrder.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }
      });
      test("In byName method", () {
        var expensesBeforeOrder = [...expenses];

        usecase.byName(expenses: expenses, isAlphabetic: true);

        expect(expensesBeforeOrder.length, equals(expenses.length));

        for (int i = 0; i < expensesBeforeOrder.length; i++) {
          expect(
            expensesBeforeOrder.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }

        usecase.byName(expenses: expenses, isAlphabetic: false);

        expect(expensesBeforeOrder.length, equals(expenses.length));
        for (int i = 0; i < expensesBeforeOrder.length; i++) {
          expect(
            expensesBeforeOrder.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }
      });
      test("In byDueDate method", () {
        var expensesBeforeOrder = [...expenses];

        usecase.byDueDate(expenses: expenses, isCrescent: true);

        expect(expensesBeforeOrder.length, equals(expenses.length));

        for (int i = 0; i < expensesBeforeOrder.length; i++) {
          expect(
            expensesBeforeOrder.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }

        usecase.byDueDate(expenses: expenses, isCrescent: false);

        expect(expensesBeforeOrder.length, equals(expenses.length));
        for (int i = 0; i < expensesBeforeOrder.length; i++) {
          expect(
            expensesBeforeOrder.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }
      });

      test("In revertOrder method", () {
        var expensesBeforeOrder = [...expenses];

        usecase.revertOrder(expenses);

        expect(expensesBeforeOrder.length, equals(expenses.length));

        for (int i = 0; i < expensesBeforeOrder.length; i++) {
          expect(
            expensesBeforeOrder.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }
      });
    });
  });
}
