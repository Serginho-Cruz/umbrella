import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';

abstract interface class GetPersons {
  AsyncResult<List<String>, Fail> call();
}
