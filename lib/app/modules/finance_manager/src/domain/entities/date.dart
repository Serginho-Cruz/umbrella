import 'package:equatable/equatable.dart';

enum DateFormat { ddmmyyyy, iso, mmddyyyy }

class Date extends Equatable implements Comparable<Date> {
  late final int day;
  late final int month;
  late final int year;

  Date({
    required int day,
    required int month,
    required int year,
  }) {
    var datetime = DateTime(year, month, day);

    this.day = datetime.day;
    this.month = datetime.month;
    this.year = datetime.year;
  }

  int get totalDaysOfMonth {
    const monthsWith31Days = [1, 3, 5, 7, 8, 10, 12];

    if (monthsWith31Days.contains(month)) {
      return 31;
    }

    //February Case
    if (month == 2) {
      return year / 4 == 0 ? 29 : 28;
    }

    return 30;
  }

  static int totalDaysOnMonth(int month, int year) {
    const monthsWith31Days = [1, 3, 5, 7, 8, 10, 12];

    if (monthsWith31Days.contains(month)) {
      return 31;
    }

    //February Case
    if (month == 2) {
      return year / 4 == 0 ? 29 : 28;
    }

    return 30;
  }

  Date add({int days = 0, int months = 0, int years = 0}) {
    if (days == 0 && months == 0 && years == 0) return copyWith();

    Date date;

    //handle cases of adding months to Dates where the destiny month has minus days
    //than this month
    if (days == 0 &&
        months != 0 &&
        Date.totalDaysOnMonth(month + months, year + years) < day) {
      date = Date(
        year: year + years,
        month: month + months,
        day: Date.totalDaysOnMonth(month + months, year + years),
      );
    } else {
      date = Date(year: year + years, month: month + months, day: day + days);
    }

    return date;
  }

  Date subtract({int days = 0, int months = 0, int years = 0}) {
    if (days == 0 && months == 0 && years == 0) return copyWith();

    Date date;

    //handle cases of adding months to Dates where the destiny month has minus days
    //than this month
    if (days == 0 &&
        months != 0 &&
        Date.totalDaysOnMonth(month - months, year - years) < day) {
      date = Date(
        year: year - years,
        month: month - months,
        day: Date.totalDaysOnMonth(month - months, year - years),
      );
    } else {
      date = Date(year: year - years, month: month - months, day: day - days);
    }

    return date;
  }

  int difference(Date other) {
    return toDateTime().difference(other.toDateTime()).inDays.abs();
  }

  bool isAfter(Date other) {
    var thisDateTime = DateTime(year, month, day);
    var otherDateTime = DateTime(other.year, other.month, other.day);

    return thisDateTime.isAfter(otherDateTime);
  }

  bool isBefore(Date other) {
    var thisDateTime = DateTime(year, month, day);
    var otherDateTime = DateTime(other.year, other.month, other.day);

    return thisDateTime.isBefore(otherDateTime);
  }

  bool isMonthAfter(Date other) {
    if (year > other.year) return true;
    if (year < other.year) return false;
    if (month > other.month) return true;

    return false;
  }

  bool isMonthBefore(Date other) {
    if (year < other.year) return true;
    if (year > other.year) return false;
    if (month < other.month) return true;

    return false;
  }

  bool isAtTheSameMonthAs(Date other) {
    return other.month == month && other.year == year;
  }

  bool get isOfActualMonth {
    var today = Date.today();

    return today.month == month && today.year == year;
  }

  String get monthName {
    return {
      1: 'Janeiro',
      2: 'Fevereiro',
      3: 'Março',
      4: 'Abril',
      5: 'Maio',
      6: 'Junho',
      7: 'Julho',
      8: 'Agosto',
      9: 'Setembro',
      10: 'Outubro',
      11: 'Novembro',
      12: 'Dezembro',
    }[month]!;
  }

  static Date today() {
    var now = DateTime.now();

    return Date(day: now.day, month: now.month, year: now.year);
  }

  DateTime toDateTime() => DateTime(year, month, day);

  static Date fromDateTime(DateTime datetime) {
    return Date(day: datetime.day, month: datetime.month, year: datetime.year);
  }

  @override
  String toString({
    DateFormat format = DateFormat.iso,
    String separator = '/',
  }) {
    String day = this.day < 10 ? '0${this.day}' : this.day.toString();
    String month = this.month < 10 ? '0${this.month}' : this.month.toString();

    return switch (format) {
      DateFormat.ddmmyyyy => '$day$separator$month$separator$year',
      DateFormat.iso => '$year$separator$month$separator$day',
      DateFormat.mmddyyyy => '$month$separator$day$separator$year',
    };
  }

  static Date parse(
    String string, {
    DateFormat usedFormat = DateFormat.iso,
    String usedSeparator = '/',
  }) {
    var separated = string.split(usedSeparator);

    return switch (usedFormat) {
      DateFormat.ddmmyyyy => Date(
          day: int.parse(separated[0]),
          month: int.parse(separated[1]),
          year: int.parse(separated[2]),
        ),
      DateFormat.iso => Date(
          year: int.parse(separated[0]),
          month: int.parse(separated[1]),
          day: int.parse(separated[2]),
        ),
      DateFormat.mmddyyyy => Date(
          month: int.parse(separated[0]),
          day: int.parse(separated[1]),
          year: int.parse(separated[2]),
        ),
    };
  }

  Date copyWith({
    int? day,
    int? month,
    int? year,
  }) {
    var date = Date(
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
    );

    var dateTime = DateTime(date.year, date.month, date.day);
    return Date.fromDateTime(dateTime);
  }

  @override
  int compareTo(Date other) {
    if (isBefore(other)) return -1;
    if (isAfter(other)) return 1;

    return 0;
  }

  @override
  List<Object?> get props => [day, month, year];
}
