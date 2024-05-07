//I Need a better name for this usecase
import 'package:result_dart/result_dart.dart';

import '../../errors/storage_fail.dart';
import '../entities/user.dart';

abstract interface class ManageLocalUser {
  AsyncResult<Unit, StorageFail> storeInLocal(User user);
  AsyncResult<User, StorageFail> getInLocal();
  AsyncResult<Unit, StorageFail> deleteInLocal();
}
