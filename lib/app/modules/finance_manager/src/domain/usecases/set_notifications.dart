import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/notifications_configuration.dart';

abstract interface class SetNotificationsConfigs {
  AsyncResult<Unit, Fail> call(NotificationsConfiguration configuration);
}
