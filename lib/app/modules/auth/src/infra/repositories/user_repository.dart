import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/errors/storage_fail.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/errors/user_fail.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/infra/datasources/user_datasource.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/infra/services/local_storage_service.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import '../../data/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final LocalStorageService _localStorageService;
  final UserDatasource _userDatasource;

  UserRepositoryImpl({
    required LocalStorageService localStorageService,
    required UserDatasource userDatasource,
  })  : _localStorageService = localStorageService,
        _userDatasource = userDatasource;

  @override
  AsyncResult<int, UserFail> register(User user) async {
    int id;

    try {
      id = await _userDatasource.register(user);
    } catch (e) {
      return GenericUserFail().toFailure();
    }

    return id.toSuccess();
  }

  @override
  AsyncResult<Unit, UserFail> update(User user) async {
    try {
      await _userDatasource.update(user);
    } catch (e) {
      return GenericUserFail().toFailure();
    }

    return unit.toSuccess();
  }

  @override
  AsyncResult<User, UserFail> getByEmail(String email) async {
    User user;

    try {
      user = await _userDatasource.getByEmail(email);
    } on UserFail catch (e) {
      return e.toFailure();
    } catch (e) {
      return GenericUserFail().toFailure();
    }

    return user.toSuccess();
  }

  @override
  AsyncResult<Unit, StorageFail> saveLocal(User user) {
    return _localStorageService.storeUser(user);
  }

  @override
  AsyncResult<User, StorageFail> retrieveLocal() {
    return _localStorageService.retrieveUser();
  }

  @override
  AsyncResult<Unit, StorageFail> deleteLocal() {
    return _localStorageService.deleteUser();
  }

  @override
  AsyncResult<Unit, UserFail> setLastLogin(User user, Date date) async {
    try {
      await _userDatasource.setLastLogin(user);
    } on UserFail catch (e) {
      return e.toFailure();
    } catch (e) {
      return GenericUserFail().toFailure();
    }

    return unit.toSuccess();
  }

  @override
  AsyncResult<Unit, UserFail> delete(User user) async {
    try {
      await _userDatasource.delete(user);
    } on UserFail catch (e) {
      return e.toFailure();
    } catch (e) {
      return GenericUserFail().toFailure();
    }

    return unit.toSuccess();
  }
}
