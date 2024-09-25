import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/common/errors/storage_fail.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/infra/services/local_storage_service.dart';

class TokenStorage implements LocalStorageService {
  final String _storagePrefix = 'PREFIX_HERE';
  final String _tokenKey = 'TOKEN_KEY_HERE';

  @override
  AsyncResult<Unit, StorageFail> storeUserToken(String token) async {
    final storage = _storage;

    try {
      storage.write(key: _tokenKey, value: token);
    } catch (_) {
      return const StoreFail().toFailure();
    }

    return unit.toSuccess();
  }

  @override
  AsyncResult<String, StorageFail> retrieveUserToken() async {
    final storage = _storage;

    String? token;

    try {
      token = await storage.read(key: _tokenKey);
    } catch (_) {
      return const RetrieveFail().toFailure();
    }

    if (token == null) return const LocalUserDoesntExist().toFailure();

    return token.toSuccess();
  }

  @override
  AsyncResult<Unit, StorageFail> deleteUserToken() async {
    final storage = _storage;

    try {
      await storage.delete(key: _tokenKey);
    } catch (_) {
      return const DeleteFail().toFailure();
    }

    return unit.toSuccess();
  }

  FlutterSecureStorage get _storage {
    final androidOptions = AndroidOptions(
      encryptedSharedPreferences: true,
      preferencesKeyPrefix: _storagePrefix,
    );

    return FlutterSecureStorage(aOptions: androidOptions);
  }
}
