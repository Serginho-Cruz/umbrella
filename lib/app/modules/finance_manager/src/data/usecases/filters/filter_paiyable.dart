import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';

import '../../../domain/entities/date.dart';

abstract class FilterPaiyable<T extends Paiyable> {
  List<T> byPaid(List<T> paiyables) =>
      paiyables.where((p) => p.remainingValue == 0.00).toList();

  List<T> byUnpaid(List<T> paiyables) =>
      paiyables.where((p) => p.remainingValue > 0.00).toList();

  List<T> byOverdue(List<T> paiyables) => paiyables
      .where((p) => p.dueDate.isBefore(Date.today()) && p.remainingValue > 0.00)
      .toList();
}
