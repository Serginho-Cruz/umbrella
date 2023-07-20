class Fail implements Exception {
  String message;
  Fail(this.message);
}

class DateError extends Fail {
  DateError(super.message);
}
