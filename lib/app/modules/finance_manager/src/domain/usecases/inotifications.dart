import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/notifications_configuration.dart';

abstract class INotifications {
  Future<Result<void, Fail>> configure(
    NotificationsConfiguration configuration,
  );
  Future<void> sendNearExpiration();
  Future<void> sendRemembering();
  Future<Result<void, Fail>> setDefault();
}
