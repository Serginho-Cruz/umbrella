import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';

import '../../domain/entities/notifications_configuration.dart';
import '../../errors/errors.dart';

abstract interface class NotificationsConfigRepository {
  AsyncResult<Unit, Fail> set(
    NotificationsConfiguration configuration,
    User user,
  );
  AsyncResult<NotificationsConfiguration, Fail> get(User user);
}
