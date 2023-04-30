extension DateTimeExtension on DateTime {
  String get date {
    String month = this.month < 10 ? '0${this.month}' : this.month.toString();
    String day = this.day < 10 ? '0${this.day}' : this.day.toString();

    return '$year-$month-$day';
  }
}
