import 'package:result_dart/result_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/errors/storage_fail.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/infra/services/local_storage_service.dart';

import '../../domain/entities/user_mapper.dart';

class SharedPreferencesStorage implements LocalStorageService {
  SharedPreferencesStorage() {
    _setPrefix();
  }

  final String _prefix = 'flutter_umbrella_echo';
  final String _prefsKey = 'user';

  @override
  AsyncResult<Unit, StorageFail> storeUser(User user) async {
    final prefs = await SharedPreferences.getInstance();

    var wasDone = await prefs.setString(_prefsKey, UserMapper.toJson(user));

    return wasDone ? const Success(unit) : Failure(StoreFail());
  }

  @override
  AsyncResult<User, StorageFail> retrieveUser() async {
    final prefs = await SharedPreferences.getInstance();

    String? userJson;

    try {
      userJson = prefs.getString(_prefsKey);
    } catch (e) {
      return Failure(RetrieveFail());
    }

    if (userJson == null) return LocalUserDoesntExist().toFailure();

    return UserMapper.fromJson(userJson).toSuccess();
  }

  @override
  AsyncResult<Unit, StorageFail> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();

    var wasRemoved = await prefs.remove(_prefsKey);

    return wasRemoved ? unit.toSuccess() : Failure(DeleteFail());
  }

  void _setPrefix() {
    SharedPreferences.setPrefix(_prefix);
  }
}
