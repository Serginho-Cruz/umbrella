import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/orders/order_incomes.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/orders/iorder_incomes.dart';

import '../../../utils/factorys/income_parcel_factory.dart';

void main() {
  late IOrderIncomes usecase;
  late List<IncomeParcel> incomes = [];

  setUp(() {
    usecase = OrderIncomes();
    incomes.clear();
    incomes.addAll(List.generate(8, (_) => IncomeParcelFactory.generate()));
  });

  group("Order Incomes Usecase is Working", () {
    group("by value orders by parcel's total value and when", () {
      test("isCrescent parameter is true returns in crescent order", () {
        final orderedList = usecase.byValue(parcels: incomes, isCrescent: true);

        expect(orderedList.length, equals(incomes.length));

        var lastOneValue = orderedList.first.totalValue;
        for (var parcel in orderedList..removeAt(0)) {
          expect(lastOneValue, lessThanOrEqualTo(parcel.totalValue));
          lastOneValue = parcel.totalValue;
        }
      });
      test("isCrescent parameter is false returns in decrescent order", () {
        final orderedList =
            usecase.byValue(parcels: incomes, isCrescent: false);

        expect(orderedList.length, equals(incomes.length));

        var lastOneValue = orderedList.first.totalValue;
        for (var parcel in orderedList..removeAt(0)) {
          expect(lastOneValue, greaterThanOrEqualTo(parcel.totalValue));
          lastOneValue = parcel.totalValue;
        }
      });
    });
    group("by name orders by parcel's income name and when", () {
      test("isCrescent parameter is true returns in crescent order", () {
        final orderedList =
            usecase.byName(parcels: incomes, isAlphabetic: true);

        expect(orderedList.length, equals(incomes.length));

        var lastOneName = orderedList.first.income.name;
        for (var parcel in orderedList..removeAt(0)) {
          expect(
            lastOneName.compareTo(parcel.income.name),
            lessThanOrEqualTo(0),
          );
          lastOneName = parcel.income.name;
        }
      });
      test("isCrescent parameter is false returns in decrescent order", () {
        final orderedList =
            usecase.byName(parcels: incomes, isAlphabetic: false);

        expect(orderedList.length, equals(incomes.length));

        var lastOneName = orderedList.first.income.name;
        for (var parcel in orderedList..removeAt(0)) {
          expect(
            lastOneName.compareTo(parcel.income.name),
            greaterThanOrEqualTo(0),
          );
          lastOneName = parcel.income.name;
        }
      });
    });
    group("by due date orders by parcel's due date and when", () {
      test("isCrescent parameter is true returns in crescent order", () {
        final orderedList =
            usecase.byDueDate(parcels: incomes, isCrescent: true);

        expect(orderedList.length, equals(incomes.length));

        var lastOneDueDate = orderedList.first.dueDate;
        for (var parcel in orderedList..removeAt(0)) {
          expect(lastOneDueDate.isBefore(parcel.dueDate), isTrue);
          lastOneDueDate = parcel.dueDate;
        }
      });
      test("isCrescent parameter is false returns in decrescent order", () {
        final orderedList =
            usecase.byDueDate(parcels: incomes, isCrescent: false);

        expect(orderedList.length, equals(incomes.length));

        var lastOneDueDate = orderedList.first.dueDate;
        for (var parcel in orderedList..removeAt(0)) {
          expect(lastOneDueDate.isAfter(parcel.dueDate), isTrue);
          lastOneDueDate = parcel.dueDate;
        }
      });
    });
    test("by ID orders by parcel's ID in crescent order", () {
      final orderedList = usecase.byID(incomes);

      expect(orderedList.length, equals(incomes.length));

      var lastOneID = orderedList.first.id;
      for (var parcel in orderedList..removeAt(0)) {
        expect(lastOneID.compareTo(parcel.id), lessThanOrEqualTo(0));
        lastOneID = parcel.id;
      }
    });
    test("revert order revert parcels order in the list", () {
      final orderedList = usecase.revertOrder(incomes);

      expect(orderedList.length, equals(incomes.length));

      int i = 0, j = orderedList.length - 1;
      while (i < orderedList.length) {
        expect(orderedList.elementAt(i), equals(incomes.elementAt(j)));
        i++;
        j--;
      }
    });
    group("Parcels List passed by parameter remains unmodified", () {
      test("In byValue method", () {
        var parcelsBeforeOrder = [...incomes];

        usecase.byValue(parcels: incomes, isCrescent: true);

        expect(parcelsBeforeOrder.length, equals(incomes.length));

        for (int i = 0; i < parcelsBeforeOrder.length; i++) {
          expect(
            parcelsBeforeOrder.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }

        usecase.byValue(parcels: incomes, isCrescent: false);

        expect(parcelsBeforeOrder.length, equals(incomes.length));
        for (int i = 0; i < parcelsBeforeOrder.length; i++) {
          expect(
            parcelsBeforeOrder.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }
      });
      test("In byName method", () {
        var parcelsBeforeOrder = [...incomes];

        usecase.byName(parcels: incomes, isAlphabetic: true);

        expect(parcelsBeforeOrder.length, equals(incomes.length));

        for (int i = 0; i < parcelsBeforeOrder.length; i++) {
          expect(
            parcelsBeforeOrder.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }

        usecase.byName(parcels: incomes, isAlphabetic: false);

        expect(parcelsBeforeOrder.length, equals(incomes.length));
        for (int i = 0; i < parcelsBeforeOrder.length; i++) {
          expect(
            parcelsBeforeOrder.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }
      });
      test("In byDueDate method", () {
        var parcelsBeforeOrder = [...incomes];

        usecase.byDueDate(parcels: incomes, isCrescent: true);

        expect(parcelsBeforeOrder.length, equals(incomes.length));

        for (int i = 0; i < parcelsBeforeOrder.length; i++) {
          expect(
            parcelsBeforeOrder.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }

        usecase.byDueDate(parcels: incomes, isCrescent: false);

        expect(parcelsBeforeOrder.length, equals(incomes.length));
        for (int i = 0; i < parcelsBeforeOrder.length; i++) {
          expect(
            parcelsBeforeOrder.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }
      });
      test("In byID method", () {
        var parcelsBeforeOrder = [...incomes];

        usecase.byID(incomes);

        expect(parcelsBeforeOrder.length, equals(incomes.length));

        for (int i = 0; i < parcelsBeforeOrder.length; i++) {
          expect(
            parcelsBeforeOrder.elementAt(i),
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
