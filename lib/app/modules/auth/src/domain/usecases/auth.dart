import 'package:result_dart/result_dart.dart';

import '../../errors/auth_fail.dart';
import '../entities/user.dart';

abstract interface class Auth {
  AsyncResult<User, AuthFail> login(String email, String password);
  AsyncResult<Unit, AuthFail> logout();
  AsyncResult<Unit, AuthFail> setLastLogin(User user);
}
