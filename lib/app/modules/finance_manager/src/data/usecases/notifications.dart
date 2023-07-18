import 'package:result_dart/result_dart.dart';
import '../gateways/inotifications_gateway.dart';
import '../repositories/iexpense_parcel_repository.dart';
import '../repositories/iinvoice_repository.dart';
import '../repositories/inotifications_repository.dart';
import '../../domain/entities/notifications_configuration.dart';
import '../../domain/usecases/inotifications.dart';
import '../../errors/errors.dart';

class ConfigureNotifications implements INotifications {
  final INotificationsRepository notificationsRepository;
  final IInvoiceRepository invoicesRepository;
  final IExpenseParcelRepository expensesParcelRepository;

  final INotificationsGateway gateway;

  ConfigureNotifications({
    required this.notificationsRepository,
    required this.expensesParcelRepository,
    required this.invoicesRepository,
    required this.gateway,
  });

  @override
  Future<Result<void, Fail>> configure(
    NotificationsConfiguration configuration,
  ) async {
    var result = await notificationsRepository(configuration);
    if (result.isError()) {
      return result;
    }

    await gateway.configureNotification(configuration);
    return const Success(2);
  }

  @override
  Future<Result<void, Fail>> setDefault() async {
    final NotificationsConfiguration configuration = _getDefaultConfiguration();
    var result = await notificationsRepository(configuration);
    if (result.isError()) {
      return result;
    }

    await gateway.configureNotification(configuration);
    return const Success(2);
  }

  @override
  Future<void> sendNearExpiration() async {
    var result = await notificationsRepository.getDaysBefore();

    int days = result.getOrDefault(_getDefaultConfiguration().daysBefore);

    var expensesResult = await expensesParcelRepository
        .getWhereExpiresOn(DateTime.now().add(Duration(days: days)));

    var invoicesResult = await invoicesRepository
        .getWhereExpiresOn(DateTime.now().add(Duration(days: days)));

    if (expensesResult.isSuccess()) {
      var expenses = expensesResult.getOrThrow();
      if (expenses.isNotEmpty) {
        gateway.sendExpensesNotification(expenses);
      }
    }

    if (invoicesResult.isSuccess()) {
      var invoices = invoicesResult.getOrThrow();
      if (invoices.isNotEmpty) {
        gateway.sendInvoicesNotification(invoices);
      }
    }
  }

  @override
  Future<void> sendRemembering() async {
    gateway.sendRememberingNotification();
  }

  NotificationsConfiguration _getDefaultConfiguration() =>
      NotificationsConfiguration(
        isToSend: true,
        daysBefore: 7,
        hourToSend: DateTime(2023, 2, 3, 20, 00),
      );
}
