import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/notifications_configuration.dart';

abstract class IConfigureNotifications {
  Result<void, Fail> call(NotificationsConfiguration configuration);
  Result<void, Fail> setDefaultConfiguration();
}
