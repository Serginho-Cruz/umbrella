import 'package:umbrella_echonomics/app/modules/auth/src/errors/messages.dart';

abstract class StorageFail implements Exception {
  final String message;

  StorageFail(this.message);
}

class StoreFail extends StorageFail {
  StoreFail() : super(Messages.storeError);
}

class RetrieveFail extends StorageFail {
  RetrieveFail() : super(Messages.retrieveError);
}

class LocalUserDoesntExist extends StorageFail {
  LocalUserDoesntExist() : super(Messages.localUserDoesntExist);
}

class DeleteFail extends StorageFail {
  DeleteFail() : super(Messages.deleteLocalUserError);
}
