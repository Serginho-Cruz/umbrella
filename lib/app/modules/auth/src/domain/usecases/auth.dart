import 'package:result_dart/result_dart.dart';

import '../../errors/fail.dart';
import '../entities/user.dart';

abstract interface class Auth {
  AsyncResult<User, Fail> login(
    String email,
    String password, {
    bool rememberUser = false,
  });
  AsyncResult<Unit, Fail> logout(User user);
  AsyncResult<User, Fail> loginWithToken(String token);
}
