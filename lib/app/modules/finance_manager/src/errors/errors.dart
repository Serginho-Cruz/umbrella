import 'generic_messages.dart';

class Fail implements Exception {
  final String message;
  const Fail(this.message);
}

class GenericError extends Fail {
  const GenericError() : super(GenericMessages.genericFail);
}

class AccountDoesntExist extends Fail {
  const AccountDoesntExist(super.message);
}

class DateError extends Fail {
  const DateError(super.message);
}

class CreditError extends Fail {
  const CreditError(super.message);
}

class InvoiceNotExist extends Fail {
  const InvoiceNotExist(super.message);
}

class InvoiceUpdateError extends Fail {
  const InvoiceUpdateError(super.message);
}

class PaymentError extends Fail {
  const PaymentError(super.message);
}

class InstallmentError extends Fail {
  const InstallmentError(super.message);
}
