import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/orders/order_expenses.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/orders/iorder_expenses.dart';

import '../../../utils/factorys/expense_parcel_factory.dart';

void main() {
  late IOrderExpenses usecase;
  late List<ExpenseParcel> expenses = [];

  setUp(() {
    usecase = OrderExpenses();
    expenses.clear();
    expenses.addAll(List.generate(8, (_) => ExpenseParcelFactory.generate()));
  });

  group("Order Expenses Usecase is Working", () {
    group("by value orders by parcel's total value and when", () {
      test("isCrescent parameter is true returns in crescent order", () {
        final orderedList =
            usecase.byValue(parcels: expenses, isCrescent: true);

        expect(orderedList.length, equals(expenses.length));

        var lastOneValue = orderedList.first.totalValue;
        for (var parcel in orderedList..removeAt(0)) {
          expect(lastOneValue, lessThanOrEqualTo(parcel.totalValue));
          lastOneValue = parcel.totalValue;
        }
      });
      test("isCrescent parameter is false returns in decrescent order", () {
        final orderedList =
            usecase.byValue(parcels: expenses, isCrescent: false);

        expect(orderedList.length, equals(expenses.length));

        var lastOneValue = orderedList.first.totalValue;
        for (var parcel in orderedList..removeAt(0)) {
          expect(lastOneValue, greaterThanOrEqualTo(parcel.totalValue));
          lastOneValue = parcel.totalValue;
        }
      });
    });
    group("by name orders by parcel's expense name and when", () {
      test("isCrescent parameter is true returns in crescent order", () {
        final orderedList =
            usecase.byName(parcels: expenses, isAlphabetic: true);

        expect(orderedList.length, equals(expenses.length));

        var lastOneName = orderedList.first.expense.name;
        for (var parcel in orderedList..removeAt(0)) {
          expect(
            lastOneName.compareTo(parcel.expense.name),
            lessThanOrEqualTo(0),
          );
          lastOneName = parcel.expense.name;
        }
      });
      test("isCrescent parameter is false returns in decrescent order", () {
        final orderedList =
            usecase.byName(parcels: expenses, isAlphabetic: false);

        expect(orderedList.length, equals(expenses.length));

        var lastOneName = orderedList.first.expense.name;
        for (var parcel in orderedList..removeAt(0)) {
          expect(
            lastOneName.compareTo(parcel.expense.name),
            greaterThanOrEqualTo(0),
          );
          lastOneName = parcel.expense.name;
        }
      });
    });
    group("by due date orders by parcel's due date and when", () {
      test("isCrescent parameter is true returns in crescent order", () {
        final orderedList =
            usecase.byDueDate(parcels: expenses, isCrescent: true);

        expect(orderedList.length, equals(expenses.length));

        var lastOneDueDate = orderedList.first.dueDate;
        for (var parcel in orderedList..removeAt(0)) {
          expect(lastOneDueDate.isBefore(parcel.dueDate), isTrue);
          lastOneDueDate = parcel.dueDate;
        }
      });
      test("isCrescent parameter is false returns in decrescent order", () {
        final orderedList =
            usecase.byDueDate(parcels: expenses, isCrescent: false);

        expect(orderedList.length, equals(expenses.length));

        var lastOneDueDate = orderedList.first.dueDate;
        for (var parcel in orderedList..removeAt(0)) {
          expect(lastOneDueDate.isAfter(parcel.dueDate), isTrue);
          lastOneDueDate = parcel.dueDate;
        }
      });
    });
    test("by ID orders by parcel's ID in crescent order", () {
      final orderedList = usecase.byID(expenses);

      expect(orderedList.length, equals(expenses.length));

      var lastOneID = orderedList.first.id;
      for (var parcel in orderedList..removeAt(0)) {
        expect(lastOneID.compareTo(parcel.id), lessThanOrEqualTo(0));
        lastOneID = parcel.id;
      }
    });
    test("revert order revert parcels order in the list", () {
      final orderedList = usecase.revertOrder(expenses);

      expect(orderedList.length, equals(expenses.length));

      int i = 0, j = orderedList.length - 1;
      while (i < orderedList.length) {
        expect(orderedList.elementAt(i), equals(expenses.elementAt(j)));
        i++;
        j--;
      }
    });
    group("Parcels List passed by parameter remains unmodified", () {
      test("In byValue method", () {
        var parcelsBeforeOrder = [...expenses];

        usecase.byValue(parcels: expenses, isCrescent: true);

        expect(parcelsBeforeOrder.length, equals(expenses.length));

        for (int i = 0; i < parcelsBeforeOrder.length; i++) {
          expect(
            parcelsBeforeOrder.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }

        usecase.byValue(parcels: expenses, isCrescent: false);

        expect(parcelsBeforeOrder.length, equals(expenses.length));
        for (int i = 0; i < parcelsBeforeOrder.length; i++) {
          expect(
            parcelsBeforeOrder.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }
      });
      test("In byName method", () {
        var parcelsBeforeOrder = [...expenses];

        usecase.byName(parcels: expenses, isAlphabetic: true);

        expect(parcelsBeforeOrder.length, equals(expenses.length));

        for (int i = 0; i < parcelsBeforeOrder.length; i++) {
          expect(
            parcelsBeforeOrder.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }

        usecase.byName(parcels: expenses, isAlphabetic: false);

        expect(parcelsBeforeOrder.length, equals(expenses.length));
        for (int i = 0; i < parcelsBeforeOrder.length; i++) {
          expect(
            parcelsBeforeOrder.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }
      });
      test("In byDueDate method", () {
        var parcelsBeforeOrder = [...expenses];

        usecase.byDueDate(parcels: expenses, isCrescent: true);

        expect(parcelsBeforeOrder.length, equals(expenses.length));

        for (int i = 0; i < parcelsBeforeOrder.length; i++) {
          expect(
            parcelsBeforeOrder.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }

        usecase.byDueDate(parcels: expenses, isCrescent: false);

        expect(parcelsBeforeOrder.length, equals(expenses.length));
        for (int i = 0; i < parcelsBeforeOrder.length; i++) {
          expect(
            parcelsBeforeOrder.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }
      });
      test("In byID method", () {
        var parcelsBeforeOrder = [...expenses];

        usecase.byID(expenses);

        expect(parcelsBeforeOrder.length, equals(expenses.length));

        for (int i = 0; i < parcelsBeforeOrder.length; i++) {
          expect(
            parcelsBeforeOrder.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }
      });
      test("In revertOrder method", () {
        var parcelsBeforeOrder = [...expenses];

        usecase.revertOrder(expenses);

        expect(parcelsBeforeOrder.length, equals(expenses.length));

        for (int i = 0; i < parcelsBeforeOrder.length; i++) {
          expect(
            parcelsBeforeOrder.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }
      });
    });
  });
}
