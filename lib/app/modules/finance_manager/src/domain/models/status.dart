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
    if (p.remainingValue == 0) {
      return Status.okay;
    }

    if (!_isInTime(p)) return Status.overdue;

    return Status.inTime;
  }

  static bool _isInTime(Paiyable p) {
    var today = Date.today();

    return (p.dueDate.isAfter(today) || p.dueDate.difference(today) == 0);
  }
}
