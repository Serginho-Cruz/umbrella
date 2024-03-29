class Fail implements Exception {
  String message;
  Fail(this.message);
}

class GenericError extends Fail {
  GenericError() : super("Um Erro inesperado aconteceu, tente novamente");
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

class InvoiceNotExist extends Fail {
  InvoiceNotExist(super.message);
}

class InvoiceUpdateError extends Fail {
  InvoiceUpdateError(super.message);
}

class InstallmentError extends Fail {
  InstallmentError(super.message);
}
