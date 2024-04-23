import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/errors/user_fail.dart';

import '../entities/user.dart';

abstract interface class ManageUser {
  AsyncResult<int, UserFail> register(User user);
  AsyncResult<Unit, UserFail> update(User oldUser, User newUser);
  AsyncResult<Unit, UserFail> delete(User user);
}
