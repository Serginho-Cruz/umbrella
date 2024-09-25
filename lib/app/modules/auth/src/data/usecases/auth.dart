import 'package:result_dart/result_dart.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/auth.dart';
import '../../domain/usecases/manage_local_token.dart';
import '../../common/errors/fail.dart';
import '../repositories/user_repository.dart';

class AuthImpl implements Auth {
  final UserRepository _repository;
  final ManageLocalToken _manageLocalToken;

  AuthImpl({
    required UserRepository repository,
    required ManageLocalToken manageLocalToken,
  })  : _repository = repository,
        _manageLocalToken = manageLocalToken;

  @override
  AsyncResult<User, Fail> login(
    String email,
    String password, {
    bool rememberUser = false,
  }) async {
    var userResult = await _repository.login(email, password);

    if (userResult.isError()) {
      return userResult;
    }

    final User user = userResult.getOrNull()!;

    if (rememberUser && user.token != null) {
      _manageLocalToken.store(user.token!);
    }

    return Success(user);
  }

  @override
  AsyncResult<Unit, Fail> logout(User user) async {
    var result = await _manageLocalToken.delete();

    if (result.isError()) {
      return result;
    }

    return _repository.logout(user);
  }

  @override
  AsyncResult<User, Fail> loginWithToken(String token) async {
    var result = await _repository.loginWithToken(token);

    if (result.isError()) _manageLocalToken.delete();

    return result;
  }
}
