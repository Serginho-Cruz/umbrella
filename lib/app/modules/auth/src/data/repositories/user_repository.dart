import 'package:result_dart/result_dart.dart';

import '../../domain/entities/user.dart';
import '../../common/errors/fail.dart';

abstract interface class UserRepository {
  AsyncResult<String, Fail> register(User user);
  AsyncResult<Unit, Fail> update(User user);
  AsyncResult<User, Fail> login(String email, String password);
  AsyncResult<User, Fail> loginWithToken(String token);
  AsyncResult<Unit, Fail> logout(User user);
  AsyncResult<Unit, Fail> delete(User user);
}
