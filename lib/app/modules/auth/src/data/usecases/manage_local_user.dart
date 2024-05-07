import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';

import 'package:umbrella_echonomics/app/modules/auth/src/errors/storage_fail.dart';

import '../../domain/usecases/manage_local_user.dart';
import '../../infra/services/local_storage_service.dart';

class ManageLocalUserImpl implements ManageLocalUser {
  final LocalStorageService _localService;

  ManageLocalUserImpl(this._localService);

  @override
  AsyncResult<Unit, StorageFail> storeInLocal(User user) async {
    var result = await _localService.storeUser(user);

    return result;
  }

  @override
  AsyncResult<User, StorageFail> getInLocal() async {
    var result = await _localService.retrieveUser();

    return result;
  }

  @override
  AsyncResult<Unit, StorageFail> deleteInLocal() async {
    var result = await _localService.deleteUser();

    return result;
  }
}
