import 'fail.dart';
import 'messages.dart';

sealed class UserFail extends Fail {
  const UserFail(super.message);
}

class GenericUserFail extends UserFail {
  const GenericUserFail() : super(Messages.genericUserFail);
}

class DatabaseProcessError extends UserFail {
  const DatabaseProcessError(super.message);
}
