enum DateFormat { ddmmyyyy, iso, mmddyyyy }

class Date {
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

  static Date fromDateTime(DateTime datetime) {
    return Date(day: datetime.day, month: datetime.month, year: datetime.year);
  }

  DateTime toDateTime() => DateTime(year, month, day);

  @override
  String toString({
    DateFormat format = DateFormat.iso,
    String? separator = '/',
  }) {
    String day = this.day < 10 ? '0${this.day}' : this.day.toString();
    String month = this.month < 10 ? '0${this.month}' : this.month.toString();

    return switch (format) {
      DateFormat.ddmmyyyy => '$day$separator$month$separator$year',
      DateFormat.iso => '$year$separator$month$separator$day',
      DateFormat.mmddyyyy => '$month$separator$day$separator$year',
    };
  }
}
