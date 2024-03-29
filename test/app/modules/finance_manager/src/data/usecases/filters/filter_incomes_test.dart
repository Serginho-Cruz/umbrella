import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/filters/filter_incomes.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/filters/ifilter_incomes.dart';

import '../../../utils/factorys/income_factory.dart';
import '../../../utils/factorys/income_type_factory.dart';

void main() {
  late IFilterIncomes usecase;
  List<Income> incomes = [];

  setUp(() {
    usecase = FilterIncomes();
    incomes.clear();
    incomes.addAll(List.generate(8, (_) => IncomeFactory.generate()));
  });

  group('Filter Incomes Usecase is Working ', () {
    test("by Received returns only totally paid parcels", () {
      incomes.addAll(List.generate(4, (_) => IncomeFactory.generateReceived()));

      var filteredIncomes = usecase.byPaid(incomes);
      expect(filteredIncomes.length, greaterThan(0));

      for (var income in filteredIncomes) {
        expect(
            income.remainingValue == 0 && income.paidValue == income.totalValue,
            isTrue);
      }
    });
    test("by Unreceived returns only not totally paid parcels", () {
      incomes.addAll(List.generate(4, (_) => IncomeFactory.generateReceived()));

      var filteredIncomes = usecase.byUnpaid(incomes);
      expect(filteredIncomes.length, greaterThan(0));

      for (var income in filteredIncomes) {
        expect(
            income.remainingValue > 0 && income.paidValue < income.totalValue,
            isTrue);
      }
    });
    test("by Name returns only parcels that contains the name", () {
      incomes.addAll(
          List.generate(5, (_) => IncomeFactory.generate(name: 'Salary')));

      var filteredIncomes = usecase.byName(
        incomes: incomes,
        searchName: 'Salary',
      );

      expect(filteredIncomes.length, greaterThan(0));
      for (var income in filteredIncomes) {
        expect(income.name.contains('Salary'), isTrue);
      }
    });
    test("by Name must be case-insensitive", () {
      incomes.addAll(
          List.generate(5, (_) => IncomeFactory.generate(name: 'SALARY')));

      var filteredLower = usecase.byName(
        incomes: incomes,
        searchName: 'salary',
      );

      var filteredEqual = usecase.byName(
        incomes: incomes,
        searchName: 'SALARY',
      );

      expect(filteredLower.length, greaterThan(0));
      expect(filteredEqual.length, greaterThan(0));

      for (var income in filteredEqual) {
        expect(filteredLower.contains(income), isTrue);
      }

      expect(filteredEqual.length, equals(filteredLower.length));
    });
    test("by Type returns only parcels where type is equals the type passed",
        () {
      var type = IncomeTypeFactory.generate();
      incomes
          .addAll(List.generate(4, (_) => IncomeFactory.generate(type: type)));

      var filteredIncomes = usecase.byType(incomes: incomes, type: type);

      expect(filteredIncomes.length, greaterThan(0));
      for (var income in filteredIncomes) {
        expect(income.type, equals(type));
      }
    });
    test("by Overdue returns only not totally paid and out of due date parcels",
        () {
      incomes.addAll(List.generate(
        4,
        (_) => IncomeFactory.generate(
            dueDate: Date.today().subtract(days: 2), paidValue: 20.15),
      ));

      var filteredIncomes = usecase.byOverdue(incomes);

      expect(filteredIncomes.length, greaterThan(0));
      for (var parcel in filteredIncomes) {
        expect(
            parcel.remainingValue > 0 && Date.today().isAfter(parcel.dueDate),
            isTrue);
      }
    });
    group("Parcels List passed by parameter remains unmodified", () {
      test("In byReceived method", () {
        incomes
            .addAll(List.generate(4, (_) => IncomeFactory.generateReceived()));
        var parcelsBeforeFilter = [...incomes];

        usecase.byPaid(incomes);

        expect(parcelsBeforeFilter.length, equals(incomes.length));

        for (int i = 0; i < parcelsBeforeFilter.length; i++) {
          expect(
            parcelsBeforeFilter.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }
      });
      test("In byUnReceived method", () {
        incomes
            .addAll(List.generate(4, (_) => IncomeFactory.generateReceived()));
        var parcelsBeforeFilter = [...incomes];

        usecase.byUnpaid(incomes);

        expect(parcelsBeforeFilter.length, equals(incomes.length));

        for (int i = 0; i < parcelsBeforeFilter.length; i++) {
          expect(
            parcelsBeforeFilter.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }
      });
      test("In byOverdue method", () {
        incomes.addAll(List.generate(
            4,
            (_) => IncomeFactory.generate(
                dueDate: Date.today().subtract(days: 2), paidValue: 20.15)));

        var parcelsBeforeFilter = [...incomes];

        usecase.byOverdue(incomes);

        expect(parcelsBeforeFilter.length, equals(incomes.length));

        for (int i = 0; i < parcelsBeforeFilter.length; i++) {
          expect(
            parcelsBeforeFilter.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }
      });
      test("In byName method", () {
        incomes.addAll(
            List.generate(4, (_) => IncomeFactory.generate(name: 'Salary')));
        var parcelsBeforeFilter = [...incomes];

        usecase.byName(incomes: incomes, searchName: 'Salary');

        expect(parcelsBeforeFilter.length, equals(incomes.length));

        for (int i = 0; i < parcelsBeforeFilter.length; i++) {
          expect(
            parcelsBeforeFilter.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }
      });
      test("In byType method", () {
        var type = IncomeTypeFactory.generate();
        incomes.addAll(
            List.generate(4, (_) => IncomeFactory.generate(type: type)));
        var parcelsBeforeFilter = [...incomes];

        usecase.byType(incomes: incomes, type: type);

        expect(parcelsBeforeFilter.length, equals(incomes.length));

        for (int i = 0; i < parcelsBeforeFilter.length; i++) {
          expect(
            parcelsBeforeFilter.elementAt(i),
            equals(incomes.elementAt(i)),
          );
        }
      });
    });
  });
}
