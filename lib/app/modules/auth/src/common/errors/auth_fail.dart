import 'fail.dart';
import 'messages.dart';

sealed class AuthFail extends Fail {
  const AuthFail(super.message);
}

final class GenericAuthFail extends AuthFail {
  const GenericAuthFail() : super(Messages.genericAuthFail);
  const GenericAuthFail.withMessage(super.message);
}

class EmailAlreadyRegistered extends AuthFail {
  const EmailAlreadyRegistered() : super(Messages.emailAlreadyRegistered);
}

final class InvalidEmail extends AuthFail {
  const InvalidEmail() : super(Messages.invalidEmail);
}

final class IncorrectCredentials extends AuthFail {
  const IncorrectCredentials() : super(Messages.incorrectCredentials);
}

final class SessionStorageExpired extends AuthFail {
  const SessionStorageExpired() : super(Messages.mustloginAgain);
}
