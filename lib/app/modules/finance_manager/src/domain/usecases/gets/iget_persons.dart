import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';

abstract class IGetPersons {
  Future<Result<List<String>, Fail>> call();
}
