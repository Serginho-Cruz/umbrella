import 'package:result_dart/result_dart.dart';

import 'package:umbrella_echonomics/app/modules/auth/src/errors/storage_fail.dart';

import '../../domain/usecases/manage_local_token.dart';
import '../../infra/services/local_storage_service.dart';

class ManageLocalTokenImpl implements ManageLocalToken {
  final LocalStorageService _localService;

  ManageLocalTokenImpl(this._localService);

  @override
  AsyncResult<Unit, StorageFail> storeInLocal(String token) async {
    var result = await _localService.storeUserToken(token);

    return result;
  }

  @override
  AsyncResult<String, StorageFail> getInLocal() async {
    var result = await _localService.retrieveUserToken();

    return result;
  }

  @override
  AsyncResult<Unit, StorageFail> deleteInLocal() async {
    var result = await _localService.deleteUserToken();

    return result;
  }
}
