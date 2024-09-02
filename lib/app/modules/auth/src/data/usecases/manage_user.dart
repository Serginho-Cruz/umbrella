import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/data/repositories/user_repository.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/usecases/manage_user.dart';

import '../../errors/fail.dart';

class ManageUserImpl implements ManageUser {
  final UserRepository _repository;

  ManageUserImpl(this._repository);

  @override
  AsyncResult<String, Fail> register(User user) {
    return _repository.register(user);
  }

  @override
  AsyncResult<Unit, Fail> update(User oldUser, User newUser) async {
    if (oldUser == newUser) return unit.toSuccess();

    return _repository.update(newUser);
  }

  @override
  AsyncResult<Unit, Fail> delete(User user) async {
    var result = await _repository.deleteLocalToken();

    if (result.isError()) return result;

    return _repository.delete(user);
  }
}
