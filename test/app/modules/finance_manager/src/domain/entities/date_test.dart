import 'package:flutter_test/flutter_test.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';

void main() {
  group('Date class is working ', () {
    group('constructor is ok ', () {
      test("instances all fields correctly", () {
        Date date = Date(day: 2, month: 5, year: 2023);

        expect(
          date.day,
          equals(2),
          reason:
              '2 was passed as the day for Date constructor, but the actual day was ${date.day}',
        );

        expect(
          date.month,
          equals(5),
          reason:
              '5 was passed as the month for Date constructor, but the actual month was ${date.month}',
        );

        expect(
          date.year,
          equals(2023),
          reason:
              '2023 was passed as the year for Date constructor, but the actual year was ${date.year}',
        );
      });
    });
    group('today method is ok ', () {
      test("returns a Date that corresponds to today's date", () {
        Date date = Date.today();
        DateTime today = DateTime.now();

        expect(
          date.day,
          equals(today.day),
          reason:
              "Today's day is ${today.day}, but Date.today returned ${date.day} as the day",
        );

        expect(
          date.month,
          equals(today.month),
          reason:
              "Today's month is ${today.month}, but Date.today returned ${date.month} as the month",
        );

        expect(
          date.year,
          equals(today.year),
          reason:
              "Today's year is ${today.year}, but Date.today returned ${date.year} as the year",
        );
      });
    });
    group('fromDatetime method is ok ', () {
      test("returns a Date that corresponds to the date from DateTime", () {
        DateTime datetime = DateTime(2022, 9, 21);

        var date = Date.fromDateTime(datetime);

        expect(
          date.day,
          equals(21),
          reason:
              'The day on the returned Date should be 21, but it was ${date.day}',
        );

        expect(
          date.month,
          equals(9),
          reason:
              'The month on the returned Date should be 9, but it was ${date.month}',
        );

        expect(
          date.year,
          equals(2022),
          reason:
              'The year on the returned Date should be 2022, but it was ${date.year}',
        );
      });
    });
    group('toDatetime method is ok ', () {
      test("returns a DateTime that corresponds to the Date", () {
        var date = Date(day: 22, month: 6, year: 2010);

        var datetime = date.toDateTime();

        expect(
          datetime.day,
          equals(22),
          reason: "DateTime's day should be 22, but it was ${datetime.day}",
        );

        expect(
          datetime.month,
          equals(6),
          reason: "DateTime's month should be 6, but it was ${datetime.month}",
        );

        expect(
          datetime.year,
          equals(2010),
          reason: "DateTime's day should be 2010, but it was ${datetime.year}",
        );
      });
    });
    group('add method is ok ', () {
      test("Adds the amount of time correctly", () {
        var date = Date(day: 12, month: 3, year: 2022);

        var addedDate1 = date.add(days: 9);

        expect(
          addedDate1.day,
          equals(21),
          reason:
              "Was added 9 days to the date(day 12), the returned date must have 21 as day",
        );

        expect(
          addedDate1.month,
          equals(3),
          reason: "Wasn't added months, so must remain unmodified",
        );

        expect(
          addedDate1.year,
          equals(2022),
          reason: "Wasn't added years, so must remain unmodified",
        );

        var addedDate2 = date.add(days: 3, months: 9);

        expect(
          addedDate2.day,
          equals(15),
          reason:
              "Was added 3 days to the date(day 12), the returned date's day must be 15",
        );

        expect(
          addedDate2.month,
          equals(12),
          reason:
              "Was added 9 months to the date(month 3), the returned date's month must be 12",
        );

        expect(
          addedDate2.year,
          equals(2022),
          reason: "Wasn't added years, so must remain unmodified",
        );

        var addedDate3 = date.add(days: 18, months: 6, years: 3);

        expect(
          addedDate3.day,
          equals(30),
          reason:
              "Was added 18 days to the date(day 12), the returned date's day must be 30",
        );

        expect(
          addedDate3.month,
          equals(9),
          reason:
              "Was added 6 months to the date(month 3), the returned date's month must be 9",
        );

        expect(
          addedDate3.year,
          equals(2025),
          reason:
              "Was added 3 years to the date(year 2022), the returned date's year must be 2025",
        );

        var addedDate4 = date.copyWith(day: 31).add(months: 3);

        expect(
          addedDate4.day,
          equals(30),
          reason:
              "the month has only 30 days and only months were added, so the day becomes the last day of the month",
        );

        expect(
          addedDate4.month,
          equals(6),
          reason:
              "Was added 3 months to the date(month 3), the returned date's month must be 6",
        );

        expect(
          addedDate4.year,
          equals(2022),
          reason: "Wasn't added years, so must remain unmodified",
        );
      });
    });
    group('subtract method is ok', () {
      test("subtracts the amount of time correctly", () {
        var date = Date(day: 12, month: 3, year: 2022);

        var subtractedDate1 = date.subtract(days: 9);

        expect(
          subtractedDate1.day,
          equals(3),
          reason:
              "Were subtracted 9 days from the date(day 12), the returned date must have 3 as day",
        );

        expect(
          subtractedDate1.month,
          equals(3),
          reason: "Weren't subtracted months, so must remain unmodified",
        );

        expect(
          subtractedDate1.year,
          equals(2022),
          reason: "Weren't subtracted years, so must remain unmodified",
        );

        var subtractedDate2 = date.subtract(days: 3, months: 9);

        expect(
          subtractedDate2.day,
          equals(9),
          reason:
              "Was subtracted 3 days from the date(day 12), the returned date's day must be 9",
        );

        expect(
          subtractedDate2.month,
          equals(6),
          reason:
              "Was subtracted 9 months from the date(month 3), the returned date's month must be 6",
        );

        expect(
          subtractedDate2.year,
          equals(2021),
          reason:
              "The amount of months subtracted causes the year to decrease to 2021",
        );

        var subtractedDate3 = date.subtract(days: 1, months: 2, years: 3);

        expect(
          subtractedDate3.day,
          equals(11),
          reason:
              "Was subtracted 1 day from the date(day 12), the returned date's day must be 11",
        );

        expect(
          subtractedDate3.month,
          equals(1),
          reason:
              "Was subtracted 2 months from the date(month 3), the returned date's month must be 1",
        );

        expect(
          subtractedDate3.year,
          equals(2019),
          reason:
              "Was subtracted 3 years from the date(year 2022), the returned date's year must be 2019",
        );

        var subtractedDate4 = date.copyWith(day: 31).subtract(months: 1);

        expect(
          subtractedDate4.day,
          equals(28),
          reason:
              "the month has only 28 days and only months were subtracted, so the day becomes the last day of the month",
        );

        expect(
          subtractedDate4.month,
          equals(2),
          reason:
              "Was subtracted 1 month from the date(month 3), the returned date's month must be 2",
        );

        expect(
          subtractedDate4.year,
          equals(2022),
          reason: "Wasn't subtracted years, so must remain unmodified",
        );
      });
    });
    group('difference is ok ', () {
      test("returns the difference in days between two dates", () {
        var date = Date(day: 18, month: 7, year: 2023);
        var date2 = Date(day: 30, month: 8, year: 2023);

        int difference = date.difference(date2);

        expect(
          difference,
          equals(43),
          reason: 'The total days of difference between the given dates is 43',
        );
      });
    });
    group('isAfter method is ok ', () {
      test("checks if the date occurs after the given date", () {
        var date = Date(day: 12, month: 4, year: 2017);
        var dateAfter = date.copyWith(day: 30);

        expect(
          dateAfter.isAfter(date),
          isTrue,
          reason:
              'The date is after the date given by parameter, must return true',
        );

        expect(
          date.isAfter(dateAfter),
          isFalse,
          reason:
              'The date is before the date given by parameter, must return false',
        );

        expect(
          date.isAfter(date),
          isFalse,
          reason:
              'The date occurs at the same date as the given by parameter, must return false',
        );
      });
    });
    group('isBefore method is ok ', () {
      test("check if the date occurs before the given date", () {
        var date = Date(day: 12, month: 4, year: 2017);
        var dateBefore = date.copyWith(day: 7);

        expect(
          dateBefore.isBefore(date),
          isTrue,
          reason:
              'The date is before the date given by parameter, must return true',
        );

        expect(
          date.isBefore(dateBefore),
          isFalse,
          reason:
              'The date is after the date given by parameter, must return false',
        );

        expect(
          date.isBefore(date),
          isFalse,
          reason:
              'The date occurs at the same date as the given by parameter, must return false',
        );
      });
    });
    group('isMonthBefore method is ok ', () {
      test("check if date occurs in a month before the given date", () {
        var date = Date(day: 15, month: 9, year: 2013);
        var sameMonth = date.copyWith(day: 3);
        var monthBefore = date.copyWith(month: 7);

        expect(
          monthBefore.isMonthBefore(date),
          isTrue,
          reason:
              "The date is of a month before the parameter's date, must return true",
        );

        expect(
          sameMonth.isMonthBefore(date),
          isFalse,
          reason:
              "The date is at the same month as parameter's date, must return false",
        );
      });
    });
    group('isMonthAfter method is ok ', () {
      test("checks if the date occurs in a month after the given date", () {
        var date = Date(day: 15, month: 9, year: 2013);
        var sameMonth = date.copyWith(day: 19);
        var monthBefore = date.copyWith(month: 12);

        expect(
          monthBefore.isMonthAfter(date),
          isTrue,
          reason:
              "The date is of a month after the parameter's date, must return true",
        );

        expect(
          sameMonth.isMonthAfter(date),
          isFalse,
          reason:
              "The date is at the same month as parameter's date, must return false",
        );
      });
    });
    group('isAtTheSameMonthAs method is ok ', () {
      test("check if the date is at the same month and year as another", () {
        var date = Date(day: 15, month: 9, year: 2013);
        var sameMonth = date.copyWith(day: 3);
        var monthBefore = date.copyWith(month: 7);
        var monthAfter = date.copyWith(month: 12);

        expect(
          monthBefore.isAtTheSameMonthAs(date),
          isFalse,
          reason:
              "The date is of a month before the parameter's date, must return false",
        );

        expect(
          monthAfter.isAtTheSameMonthAs(date),
          isFalse,
          reason:
              "The date is of a month after the parameter's date, must return false",
        );

        expect(
          sameMonth.isAtTheSameMonthAs(date),
          isTrue,
          reason:
              "The date is at the same month as parameter's date, must return true",
        );
      });
    });
    group('isOfActualMonth is ok ', () {
      test("checks if date is of this month(same month and year as today's)",
          () {
        var actualMonthDate = Date.today().copyWith(day: 8);
        var nonActualMonthDate =
            Date.today().copyWith(month: actualMonthDate.month - 1);

        expect(
          actualMonthDate.isOfActualMonth,
          isTrue,
          reason:
              "The month and the year of the date are the same as today's, must return true",
        );

        expect(
          nonActualMonthDate.isOfActualMonth,
          isFalse,
          reason:
              "The month or the year of the date aren't the same as today's, must return false",
        );
      });
    });
  });
}
