import 'package:result_dart/result_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/common/errors/storage_fail.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/infra/services/local_storage_service.dart';

class TokenStorage implements LocalStorageService {
  final String _tokenKey = 'TOKEN_KEY_HERE';

  @override
  AsyncResult<Unit, StorageFail> storeUserToken(String token) async {
    final storage = await _storage;

    try {
      await storage.setString(_tokenKey, token);
    } catch (_) {
      return const StoreFail().toFailure();
    }

    return unit.toSuccess();
  }

  @override
  AsyncResult<String, StorageFail> retrieveUserToken() async {
    final storage = await _storage;

    String? token;

    try {
      token = storage.getString(_tokenKey);
    } catch (_) {
      return const RetrieveFail().toFailure();
    }

    if (token == null) return const LocalUserDoesntExist().toFailure();

    return token.toSuccess();
  }

  @override
  AsyncResult<Unit, StorageFail> deleteUserToken() async {
    final storage = await _storage;

    try {
      await storage.remove(_tokenKey);
    } catch (_) {
      return const DeleteFail().toFailure();
    }

    return unit.toSuccess();
  }

  Future<SharedPreferences> get _storage {
    return SharedPreferences.getInstance();
  }
}
