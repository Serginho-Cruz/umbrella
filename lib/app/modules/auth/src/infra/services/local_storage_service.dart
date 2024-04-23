import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/errors/storage_fail.dart';

import '../../domain/entities/user.dart';

abstract interface class LocalStorageService {
  AsyncResult<Unit, StorageFail> storeUser(User user);
  AsyncResult<Unit, StorageFail> deleteUser();
  AsyncResult<User, StorageFail> retrieveUser();
}
