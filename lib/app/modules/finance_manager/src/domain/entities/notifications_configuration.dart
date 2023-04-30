class NotificationsConfiguration {
  bool isToSend;
  int daysBefore;
  DateTime hourToSend;

  NotificationsConfiguration({
    required this.isToSend,
    required this.daysBefore,
    required this.hourToSend,
  });
}
