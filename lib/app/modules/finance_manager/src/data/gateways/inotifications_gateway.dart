import '../../domain/entities/expense.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/notifications_configuration.dart';

abstract class INotificationsGateway {
  Future<void> configureNotification(NotificationsConfiguration configuration);
  Future<void> sendExpensesNotification(List<Expense> expenses);
  Future<void> sendInvoicesNotification(List<Invoice> invoices);
  Future<void> sendRememberingNotification();
}
