import 'messages.dart';

abstract class AuthFail implements Exception {
  final String message;

  AuthFail(this.message);
}

class GenericAuthFail extends AuthFail {
  GenericAuthFail() : super(Messages.genericAuthFail);
  GenericAuthFail.withMessage(super.message);
}

class UserNotFoundWithEmail extends AuthFail {
  UserNotFoundWithEmail(String email)
      : super("Não foi encontrado nenhum usuário com o e-mail: $email");
}

class IncorrectPassword extends AuthFail {
  IncorrectPassword() : super(Messages.incorrectPassword);
}
