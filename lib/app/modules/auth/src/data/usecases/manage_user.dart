import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/data/repositories/user_repository.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/usecases/manage_user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/errors/user_fail.dart';

class ManageUserImpl implements ManageUser {
  final UserRepository _repository;

  ManageUserImpl(this._repository);

  @override
  AsyncResult<int, UserFail> register(User user) async {
    //Cryptograph User password and email before any operation

    var emailSearch = await _repository.getByEmail(user.email);

    if (emailSearch.isSuccess()) return Failure(EmailAlreadyRegistered());

    if (emailSearch.exceptionOrNull()! != UserDoesntExist()) {
      return emailSearch.map((_) => 1);
    }

    return _repository.register(user);
  }

  @override
  AsyncResult<Unit, UserFail> update(User oldUser, User newUser) async {
    if (oldUser == newUser) return unit.toSuccess();
    //Validate email
    //Cryptograph User password and email

    if (oldUser.email != newUser.email) {
      var emailSearch = await _repository.getByEmail(newUser.email);

      if (emailSearch.isSuccess()) return Failure(EmailAlreadyRegistered());

      if (emailSearch.exceptionOrNull()! != UserDoesntExist()) {
        return emailSearch.map((_) => unit);
      }
    }

    return _repository.update(newUser);
  }

  @override
  AsyncResult<Unit, UserFail> delete(User user) {
    return _repository.delete(user);
  }
}
