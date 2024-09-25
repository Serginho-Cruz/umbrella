import 'package:result_dart/result_dart.dart';

import '../../common/errors/storage_fail.dart';

abstract interface class ManageLocalToken {
  AsyncResult<Unit, StorageFail> store(String token);
  AsyncResult<String, StorageFail> get();
  AsyncResult<Unit, StorageFail> delete();
}
