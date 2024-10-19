import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/common/errors/auth_fail.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/common/errors/user_fail.dart';
import '../../common/errors/fail.dart';
import '../datasources/user_datasource.dart';
import '../../data/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDatasource _userDatasource;

  UserRepositoryImpl(this._userDatasource);

  @override
  AsyncResult<String, Fail> register(User user) async {
    String id;

    try {
      id = await _userDatasource.register(user);
    } on Fail catch (e) {
      return e.toFailure();
    } catch (e) {
      return const GenericUserFail().toFailure();
    }

    return id.toSuccess();
  }

  @override
  AsyncResult<Unit, Fail> update(User user) async {
    try {
      await _userDatasource.update(user);
    } on Fail catch (e) {
      return e.toFailure();
    } catch (e) {
      return const GenericUserFail().toFailure();
    }

    return unit.toSuccess();
  }

  @override
  AsyncResult<User, Fail> login(String email, String password) async {
    User user;

    try {
      user = await _userDatasource.login(email, password);
    } on Fail catch (f) {
      return f.toFailure();
    } catch (e) {
      return GenericAuthFail.withMessage(e.toString()).toFailure();
    }

    return user.toSuccess();
  }

  @override
  AsyncResult<User, Fail> loginWithToken(String token) async {
    User user;

    try {
      user = await _userDatasource.loginWithToken(token);
    } on Fail catch (f) {
      return f.toFailure();
    } catch (_) {
      return const Failure(GenericAuthFail());
    }

    return user.toSuccess();
  }

  @override
  AsyncResult<Unit, Fail> logout(User user) async {
    try {
      await _userDatasource.logout(user);
    } on Fail catch (e) {
      return e.toFailure();
    } catch (e) {
      return const GenericAuthFail().toFailure();
    }

    return unit.toSuccess();
  }

  @override
  AsyncResult<Unit, Fail> delete(User user) async {
    try {
      await _userDatasource.delete(user);
    } on Fail catch (e) {
      return e.toFailure();
    } catch (e) {
      return const GenericUserFail().toFailure();
    }

    return unit.toSuccess();
  }
}
