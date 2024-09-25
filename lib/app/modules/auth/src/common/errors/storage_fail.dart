import 'package:umbrella_echonomics/app/modules/auth/src/common/errors/messages.dart';

import 'fail.dart';

sealed class StorageFail extends Fail {
  const StorageFail(super.message);
}

final class StoreFail extends StorageFail {
  const StoreFail() : super(Messages.storeError);
}

final class RetrieveFail extends StorageFail {
  const RetrieveFail() : super(Messages.retrieveError);
}

final class LocalUserDoesntExist extends StorageFail {
  const LocalUserDoesntExist() : super(Messages.localUserDoesntExist);
}

final class DeleteFail extends StorageFail {
  const DeleteFail() : super(Messages.deleteLocalUserError);
}
