class Fail implements Exception {
  String message;
  Fail(this.message);
}

class DateError extends Fail {
  DateError(super.message);
}

class InvalidValue extends Fail {
  InvalidValue(super.message);
}

class CreditError extends Fail {
  CreditError(super.message);
}
