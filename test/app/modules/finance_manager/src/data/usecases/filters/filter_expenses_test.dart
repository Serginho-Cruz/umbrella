import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/filters/filter_expenses.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/filters/ifilter_expenses.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../utils/factorys/expense_factory.dart';
import '../../../utils/factorys/expense_type_factory.dart';

void main() {
  late IFilterExpenses usecase;
  List<Expense> expenses = [];

  setUp(() {
    usecase = FilterExpenses();
    expenses.clear();
    expenses.addAll(List.generate(8, (_) => ExpenseFactory.generate()));
  });

  group('Filter Expenses Usecase is Working ', () {
    test("by Paid returns only totally paid parcels", () {
      expenses.addAll(List.generate(4, (_) => ExpenseFactory.generatePaid()));

      var filteredExpenses = usecase.byPaid(expenses);
      expect(filteredExpenses.length, greaterThan(0));

      for (var expense in filteredExpenses) {
        expect(
            expense.remainingValue == 0 &&
                expense.paidValue == expense.totalValue,
            isTrue);
      }
    });
    test("by Unpaid returns only not totally paid parcels", () {
      expenses.addAll(List.generate(4, (_) => ExpenseFactory.generatePaid()));

      var filteredExpenses = usecase.byUnpaid(expenses);
      expect(filteredExpenses.length, greaterThan(0));

      for (var expense in filteredExpenses) {
        expect(expense.remainingValue > 0, isTrue);
      }
    });
    test("by Name returns only parcels that contains the name", () {
      expenses.addAll(
          List.generate(5, (_) => ExpenseFactory.generate(name: 'Bank')));

      var filteredExpenses = usecase.byName(
        expenses: expenses,
        searchName: 'Bank',
      );

      expect(filteredExpenses.length, greaterThan(0));
      for (var expense in filteredExpenses) {
        expect(expense.name.contains('Bank'), isTrue);
      }
    });
    test("by Name must be case-insensitive", () {
      expenses.addAll(
          List.generate(5, (_) => ExpenseFactory.generate(name: 'BANK')));

      var filteredLower = usecase.byName(
        expenses: expenses,
        searchName: 'bank',
      );

      var filteredEqual = usecase.byName(
        expenses: expenses,
        searchName: 'BANK',
      );

      expect(filteredLower.length, greaterThan(0));
      expect(filteredEqual.length, greaterThan(0));

      for (var expense in filteredEqual) {
        expect(filteredLower.contains(expense), isTrue);
      }

      expect(filteredEqual.length, equals(filteredLower.length));
    });
    test("by Type returns only parcels where type is equals the type passed",
        () {
      var type = ExpenseTypeFactory.generate();
      expenses
          .addAll(List.generate(4, (_) => ExpenseFactory.generate(type: type)));

      var filteredExpenses = usecase.byType(expenses: expenses, type: type);

      expect(filteredExpenses.length, greaterThan(0));
      for (var expense in filteredExpenses) {
        expect(expense.type, equals(type));
      }
    });
    test("by Overdue returns only not totally paid and out of due date parcels",
        () {
      expenses.addAll(List.generate(
        4,
        (_) => ExpenseFactory.generate(
          totalValue: 105.25,
          dueDate: Date.today().subtract(days: 2),
          paidValue: 20.15,
        ),
      ));

      var filteredExpenses = usecase.byOverdue(expenses);

      expect(filteredExpenses.length, greaterThan(0));
      for (var expense in filteredExpenses) {
        expect(
            expense.remainingValue > 0 && Date.today().isAfter(expense.dueDate),
            isTrue);
      }
    });
    group("Parcels List passed by parameter remains unmodified", () {
      test("In byPaid method", () {
        expenses.addAll(List.generate(4, (_) => ExpenseFactory.generatePaid()));
        var expensesBeforeFilter = [...expenses];

        usecase.byPaid(expenses);

        expect(expensesBeforeFilter.length, equals(expenses.length));

        for (int i = 0; i < expensesBeforeFilter.length; i++) {
          expect(
            expensesBeforeFilter.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }
      });
      test("In byUnpaid method", () {
        expenses.addAll(List.generate(4, (_) => ExpenseFactory.generatePaid()));
        var parcelsBeforeFilter = [...expenses];

        usecase.byUnpaid(expenses);

        expect(parcelsBeforeFilter.length, equals(expenses.length));

        for (int i = 0; i < parcelsBeforeFilter.length; i++) {
          expect(
            parcelsBeforeFilter.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }
      });
      test("In byOverdue method", () {
        expenses.addAll(List.generate(
            4,
            (_) => ExpenseFactory.generate(
                dueDate: Date.today().subtract(days: 2), paidValue: 20.15)));

        var parcelsBeforeFilter = [...expenses];

        usecase.byOverdue(expenses);

        expect(parcelsBeforeFilter.length, equals(expenses.length));

        for (int i = 0; i < parcelsBeforeFilter.length; i++) {
          expect(
            parcelsBeforeFilter.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }
      });
      test("In byName method", () {
        expenses.addAll(
            List.generate(4, (_) => ExpenseFactory.generate(name: 'Bank')));
        var parcelsBeforeFilter = [...expenses];

        usecase.byName(expenses: expenses, searchName: 'Bank');

        expect(parcelsBeforeFilter.length, equals(expenses.length));

        for (int i = 0; i < parcelsBeforeFilter.length; i++) {
          expect(
            parcelsBeforeFilter.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }
      });
      test("In byType method", () {
        var type = ExpenseTypeFactory.generate();
        expenses.addAll(
            List.generate(4, (_) => ExpenseFactory.generate(type: type)));
        var parcelsBeforeFilter = [...expenses];

        usecase.byType(expenses: expenses, type: type);

        expect(parcelsBeforeFilter.length, equals(expenses.length));

        for (int i = 0; i < parcelsBeforeFilter.length; i++) {
          expect(
            parcelsBeforeFilter.elementAt(i),
            equals(expenses.elementAt(i)),
          );
        }
      });
    });
  });
}
