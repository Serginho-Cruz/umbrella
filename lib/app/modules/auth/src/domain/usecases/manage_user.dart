import 'package:result_dart/result_dart.dart';

import '../../common/errors/fail.dart';
import '../../domain/entities/user.dart';

abstract interface class ManageUser {
  AsyncResult<String, Fail> register(User user);
  AsyncResult<Unit, Fail> update(User oldUser, User newUser);
  AsyncResult<Unit, Fail> delete(User user);
}
