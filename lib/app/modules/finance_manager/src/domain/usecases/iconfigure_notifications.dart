import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/notifications_configuration.dart';

abstract class IConfigureNotifications {
  Future<Result<void, Fail>> call(NotificationsConfiguration configuration);
  Future<Result<void, Fail>> setDefaultConfiguration();
}
