import '../entities/date.dart';
import '../entities/paiyable.dart';

enum Status { okay, inTime, overdue }

extension StatusUtils on Status {
  String get adaptedName => switch (this) {
        Status.okay => 'Paga',
        Status.inTime => 'Em Tempo',
        Status.overdue => 'Vencida',
      };

  static Status resolveForPaiyable(Paiyable p) {
    if (_isInTime(p) && p.remainingValue == 0) {
      return Status.okay;
    }

    if (_isInTime(p) && p.remainingValue != 0) return Status.inTime;

    return Status.overdue;
  }

  static bool _isInTime(Paiyable p) {
    var today = Date.today();

    return (p.dueDate.isBefore(today) || p.dueDate.difference(today) == 0);
  }
}
