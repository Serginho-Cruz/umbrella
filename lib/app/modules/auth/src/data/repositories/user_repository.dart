import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/errors/storage_fail.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/errors/user_fail.dart';

import '../../../../finance_manager/src/domain/entities/date.dart';
import '../../domain/entities/user.dart';

abstract interface class UserRepository {
  AsyncResult<int, UserFail> register(User user);
  AsyncResult<Unit, UserFail> update(User user);
  AsyncResult<User, UserFail> getByEmail(String email);
  AsyncResult<Unit, UserFail> setLastLogin(User user, Date date);
  AsyncResult<Unit, StorageFail> saveLocal(User user);
  AsyncResult<User, StorageFail> retrieveLocal();
  AsyncResult<Unit, StorageFail> deleteLocal();
  AsyncResult<Unit, UserFail> delete(User user);
}
