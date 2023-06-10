import 'package:result_dart/result_dart.dart';

import '../../domain/entities/notifications_configuration.dart';
import '../../errors/errors.dart';

abstract class INotificationsRepository {
  Future<Result<void, Fail>> call(NotificationsConfiguration configuration);
  Future<Result<int, Fail>> getDaysBefore();
}
