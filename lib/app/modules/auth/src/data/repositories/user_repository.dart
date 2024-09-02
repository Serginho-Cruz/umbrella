import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/errors/storage_fail.dart';

import '../../domain/entities/user.dart';
import '../../errors/fail.dart';

abstract interface class UserRepository {
  AsyncResult<String, Fail> register(User user);
  AsyncResult<Unit, Fail> update(User user);
  AsyncResult<User, Fail> login(String email, String password);
  AsyncResult<User, Fail> loginWithToken(String token);
  AsyncResult<Unit, Fail> logout(User user);
  AsyncResult<Unit, StorageFail> saveTokenLocally(String token);
  AsyncResult<String, StorageFail> retrieveTokenLocally();
  AsyncResult<Unit, StorageFail> deleteLocalToken();
  AsyncResult<Unit, Fail> delete(User user);
}
