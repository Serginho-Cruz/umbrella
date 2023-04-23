class NotificationsConfiguration {
  bool isToSend;
  int daysBefore;
  DateTime hourToSend;
  Set<NotifyReasons> reasons;

  NotificationsConfiguration({
    required this.isToSend,
    required this.daysBefore,
    required this.hourToSend,
    required this.reasons,
  });
}

enum NotifyReasons {
  invoiceClose,
  invoiceExpiration,
  expenseExpiration,
  incomeReceive,
}
