import 'package:result_dart/result_dart.dart';
import '../repositories/inotifications_repository.dart';
import '../../domain/entities/notifications_configuration.dart';
import '../../domain/usecases/iconfigure_notifications.dart';
import '../../errors/errors.dart';

class ConfigureNotificationsUC implements IConfigureNotifications {
  final INotificationsRepository repository;

  ConfigureNotificationsUC(this.repository);

  @override
  Future<Result<void, Fail>> call(
    NotificationsConfiguration configuration,
  ) async {
    var result = await repository(configuration);
    return result;
  }

  @override
  Future<Result<void, Fail>> setDefault() async {
    var result = await repository(_getDefaultConfiguration());
    return result;
  }

  NotificationsConfiguration _getDefaultConfiguration() =>
      NotificationsConfiguration(
        isToSend: true,
        daysBefore: 7,
        hourToSend: DateTime(2023, 2, 3, 20, 00),
      );
}
