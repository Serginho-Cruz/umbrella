import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/common/errors/storage_fail.dart';

abstract interface class LocalStorageService {
  AsyncResult<Unit, StorageFail> storeUserToken(String token);
  AsyncResult<Unit, StorageFail> deleteUserToken();
  AsyncResult<String, StorageFail> retrieveUserToken();
}
