import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/orders/order_incomes.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/orders/iorder_incomes.dart';

import '../../../utils/factorys/income_factory.dart';

void main() {
  late IOrderIncomes usecase;
  late List<Income> incomes = [];

  setUp(() {
    usecase = OrderIncomes();
    incomes.clear();
    incomes.addAll(List.generate(8, (_) => IncomeFactory.generate()));
  });

  group("Order Incomes Usecase is Working", () {
    group("by value orders by income's total value and when", () {
      test("isCrescent parameter is true returns in crescent order", () {
        final orderedList = usecase.byValue(incomes: incomes, isCrescent: true);

        expect(orderedList.length, equals(incomes.length));

        var lastOneValue = orderedList.first.totalValue;
        for (var income in orderedList..removeAt(0)) {
          expect(lastOneValue, lessThanOrEqualTo(income.totalValue));
          lastOneValue = income.totalValue;
        }
      });
      test("isCrescent parameter is false returns in decrescent order", () {
        final orderedList =
            usecase.byValue(incomes: incomes, isCrescent: false);

        expect(orderedList.length, equals(incomes.length));

        var lastOneValue = orderedList.first.totalValue;
        for (var income in orderedList..removeAt(0)) {
          expect(lastOneValue, greaterThanOrEqualTo(income.totalValue));
          lastOneValue = income.totalValue;
        }
      });
    });
    group("by name orders by income's income name and when", () {
      test("isCrescent parameter is true returns in crescent order", () {
        final orderedList =
            usecase.byName(incomes: incomes, isAlphabetic: true);

        expect(orderedList.length, equals(incomes.length));

        var lastOneName = orderedList.first.name;
        for (var income in orderedList..removeAt(0)) {
          expect(
            lastOneName.compareTo(income.name),
            lessThanOrEqualTo(0),
          );
          lastOneName = income.name;
        }
      });
      test("isCrescent parameter is false returns in decrescent order", () {
        final orderedList =
            usecase.byName(incomes: incomes, isAlphabetic: false);

        expect(orderedList.length, equals(incomes.length));

        var lastOneName = orderedList.first.name;
        for (var income in orderedList..removeAt(0)) {
          expect(
            lastOneName.compareTo(income.name),
            greaterThanOrEqualTo(0),
          );
          lastOneName = income.name;
        }
      });
    });
    group("by due date orders by income's due date and when", () {
      test("isCrescent parameter is true returns in crescent order", () {
        final orderedList =
            usecase.byDueDate(incomes: incomes, isCrescent: true);

        expect(orderedList.length, equals(incomes.length));

        var lastOneDueDate = orderedList.first.dueDate;
        for (var income in orderedList..removeAt(0)) {
          expect(lastOneDueDate.isBefore(income.dueDate), isTrue);
          lastOneDueDate = income.dueDate;
        }
      });
      test("isCrescent parameter is false returns in decrescent order", () {
        final orderedList =
            usecase.byDueDate(incomes: incomes, isCrescent: false);

        expect(orderedList.length, equals(incomes.length));

        var lastOneDueDate = orderedList.first.dueDate;
        for (var income in orderedList..removeAt(0)) {
          expect(lastOneDueDate.isAfter(income.dueDate), isTrue);
          lastOneDueDate = income.dueDate;
        }
      });
    });

    test("revert order revert incomes order in the list", () {
      final orderedList = usecase.revertOrder(incomes);

      expect(orderedList.length, equals(incomes.length));

      int i = 0, j = orderedList.length - 1;
      while (i < orderedList.length) {
        expect(orderedList.elementAt(i), equals(incomes.elementAt(j)));
        i++;
        j--;
      }
    });
    group("incomes List passed by parameter remains unmodified", () {
      test("In byValue method", () {
        var incomesBeforeOrder = [...incomes];

        usecase.byValue(incomes: incomes, isCrescent: true);

        expect(incomesBeforeOrder.length, equals(incomes.length));

        for (int i = 0; i < incomesBeforeOrder.length; i++) {
          expect(
            incomesBeforeOrder.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }

        usecase.byValue(incomes: incomes, isCrescent: false);

        expect(incomesBeforeOrder.length, equals(incomes.length));
        for (int i = 0; i < incomesBeforeOrder.length; i++) {
          expect(
            incomesBeforeOrder.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }
      });
      test("In byName method", () {
        var incomesBeforeOrder = [...incomes];

        usecase.byName(incomes: incomes, isAlphabetic: true);

        expect(incomesBeforeOrder.length, equals(incomes.length));

        for (int i = 0; i < incomesBeforeOrder.length; i++) {
          expect(
            incomesBeforeOrder.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }

        usecase.byName(incomes: incomes, isAlphabetic: false);

        expect(incomesBeforeOrder.length, equals(incomes.length));
        for (int i = 0; i < incomesBeforeOrder.length; i++) {
          expect(
            incomesBeforeOrder.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }
      });
      test("In byDueDate method", () {
        var incomesBeforeOrder = [...incomes];

        usecase.byDueDate(incomes: incomes, isCrescent: true);

        expect(incomesBeforeOrder.length, equals(incomes.length));

        for (int i = 0; i < incomesBeforeOrder.length; i++) {
          expect(
            incomesBeforeOrder.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }

        usecase.byDueDate(incomes: incomes, isCrescent: false);

        expect(incomesBeforeOrder.length, equals(incomes.length));
        for (int i = 0; i < incomesBeforeOrder.length; i++) {
          expect(
            incomesBeforeOrder.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }
      });

      test("In revertOrder method", () {
        var incomesBeforeOrder = [...incomes];

        usecase.revertOrder(incomes);

        expect(incomesBeforeOrder.length, equals(incomes.length));

        for (int i = 0; i < incomesBeforeOrder.length; i++) {
          expect(
            incomesBeforeOrder.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }
      });
    });
  });
}
