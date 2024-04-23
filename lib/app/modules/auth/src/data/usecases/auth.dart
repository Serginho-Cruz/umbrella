import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/data/repositories/user_repository.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';

import 'package:umbrella_echonomics/app/modules/auth/src/errors/auth_fail.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/errors/user_fail.dart';

import '../../../../finance_manager/src/domain/entities/date.dart';
import '../../domain/usecases/auth.dart';

class AuthUImpl implements Auth {
  final UserRepository _repository;

  AuthUImpl(this._repository);

  @override
  AsyncResult<User, AuthFail> login(String email, String password) async {
    //Cryptograph email and password
    var emailSearch = await _repository.getByEmail(email);

    if (emailSearch.isError()) {
      return switch (emailSearch.exceptionOrNull()!) {
        UserDoesntExist() => Failure(UserNotFoundWithEmail(email)),
        _ => GenericAuthFail().toFailure(),
      };
    }

    User user = emailSearch.getOrNull()!;

    if (user.password != password) return IncorrectPassword().toFailure();

    return Success(user);
  }

  @override
  AsyncResult<Unit, AuthFail> logout() async {
    var result = await _repository.deleteLocal();

    if (result.isError()) {
      var message = result.exceptionOrNull()!.message;
      return GenericAuthFail.withMessage(message).toFailure();
    }

    return unit.toSuccess();
  }

  @override
  Future<AuthFail?> saveLocal(User user) async {
    var result = await _repository.saveLocal(user);

    return result.isError()
        ? GenericAuthFail.withMessage(result.exceptionOrNull()!.message)
        : null;
  }

  @override
  Future<User?> searchLocal() async {
    var result = await _repository.retrieveLocal();

    return result.getOrNull();
  }

  @override
  AsyncResult<Unit, AuthFail> setLastLogin(User user) async {
    await _repository.setLastLogin(user, Date.today());
    return unit.toSuccess();
  }
}
