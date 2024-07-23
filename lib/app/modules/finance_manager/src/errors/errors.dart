class Fail implements Exception {
  String message;
  Fail(this.message);
}

class NetworkFail extends Fail {
  NetworkFail()
      : super('Houve um problema de conexão. Cheque e tente novamente');
}

class AccountDoesntExist extends Fail {
  AccountDoesntExist(super.meesage);
}

class GenericError extends Fail {
  GenericError() : super("Um Erro inesperado aconteceu, tente novamente");
}

class DateError extends Fail {
  DateError(super.message);
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

class PaymentError extends Fail {
  PaymentError(super.message);
}

class InstallmentError extends Fail {
  InstallmentError(super.message);
}
