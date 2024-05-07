import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/data/repositories/user_repository.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';

import 'package:umbrella_echonomics/app/modules/auth/src/errors/auth_fail.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/errors/user_fail.dart';

import '../../../../finance_manager/src/domain/entities/date.dart';
import '../../domain/usecases/auth.dart';

class AuthImpl implements Auth {
  final UserRepository _repository;

  AuthImpl(this._repository);

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

    setLastLogin(user);
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
  AsyncResult<Unit, AuthFail> setLastLogin(User user) async {
    await _repository.setLastLogin(user, Date.today());
    return unit.toSuccess();
  }
}
