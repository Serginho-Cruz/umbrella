import 'package:mobx/mobx.dart';

import '../../domain/entities/date.dart';
part 'month_store.g.dart';

class MonthStore = _MonthStoreBase with _$MonthStore;

abstract class _MonthStoreBase with Store {
  @observable
  ({int year, int month}) month =
      (year: Date.today().year, month: Date.today().month);

  _MonthStoreBase();

  @action
  void set(Date date) {
    month = (month: date.month, year: date.year);
  }

  @action
  void moveToNext() {
    var actual = Date(day: 1, month: month.month, year: month.year);

    var next = actual.add(months: 1);

    month = (year: next.year, month: next.month);
  }

  @action
  void moveToPrevious() {
    var actual = Date(day: 1, month: month.month, year: month.year);

    var previous = actual.subtract(months: 1);

    month = (year: previous.year, month: previous.month);
  }
}
