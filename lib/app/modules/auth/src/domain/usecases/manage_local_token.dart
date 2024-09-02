import 'package:result_dart/result_dart.dart';

import '../../errors/storage_fail.dart';

abstract interface class ManageLocalToken {
  AsyncResult<Unit, StorageFail> storeInLocal(String token);
  AsyncResult<String, StorageFail> getInLocal();
  AsyncResult<Unit, StorageFail> deleteInLocal();
}
