import 'messages.dart';

abstract class UserFail implements Exception {
  final String message;

  UserFail(this.message);
}

class GenericUserFail extends UserFail {
  GenericUserFail() : super(Messages.genericUserFail);
}

class EmailAlreadyRegistered extends UserFail {
  EmailAlreadyRegistered() : super(Messages.emailAlreadyRegistered);
}

class UserDoesntExist extends UserFail {
  UserDoesntExist() : super(Messages.userDoesntExist);
}

class DatabaseProcessError extends UserFail {
  DatabaseProcessError(super.message);
}
