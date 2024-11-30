import 'package:mobx/mobx.dart';

import '../../domain/entities/date.dart';
import '../../domain/entities/paiyable.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/payment_record.dart';
import '../../domain/states/state.dart';
import '../../domain/usecases/filters/filter_payment_records.dart';
import '../../domain/usecases/gets/get_payment_records.dart';
import '../../domain/usecases/sorts/sort_payment_records.dart';
import 'account_store.dart';
import 'month_store.dart';
part 'payment_record_store.g.dart';

class PaymentRecordStore = _PaymentRecordStoreBase with _$PaymentRecordStore;

abstract class _PaymentRecordStoreBase with Store {
  final GetPaymentRecords _get;
  final FilterPaymentRecords _filter;
  final SortPaymentRecords _sort;
  final MonthStore _monthStore;
  final AccountStore _accountStore;

  _PaymentRecordStoreBase({
    required GetPaymentRecords getUsecase,
    required FilterPaymentRecords filterUsecase,
    required SortPaymentRecords sort,
    required MonthStore monthStore,
    required AccountStore accountStore,
  })  : _get = getUsecase,
        _filter = filterUsecase,
        _sort = sort,
        _monthStore = monthStore,
        _accountStore = accountStore;

  @observable
  State<Map<int, List<PaymentRecord<Paiyable>>>> state =
      const InitialState<Map<int, List<PaymentRecord<Paiyable>>>>();

  @computed
  ({double min, double max}) get minAndMax {
    if (state is! SuccessState<Map<int, List<PaymentRecord<Paiyable>>>>) {
      return (min: 0.00, max: 0.00);
    }

    var map =
        (state as SuccessState<Map<int, List<PaymentRecord<Paiyable>>>>).state;

    List<PaymentRecord> list = [];
    for (var records in map.values) {
      list.addAll(List.from(records)); // Criação de cópias das listas
    }

    if (list.isEmpty) return (min: 0.00, max: 0.00);

    list.sort((record1, record2) => record1.value.compareTo(record2.value));

    return (min: list.first.value, max: list.last.value);
  }

  @observable
  ObservableMap<int, List<PaymentRecord<Paiyable>>> filteredState =
      ObservableMap();

  @observable
  PaymentRecordType? filteredOrigin;

  @observable
  double minValueRange = 0.00;

  @observable
  double maxValueRange = 0.00;

  @observable
  Date firstDateRange = Date.today().copyWith(day: 1);

  @observable
  Date lastDateRange =
      Date.today().copyWith(day: Date.today().totalDaysOfMonth);

  @observable
  ObservableList<PaymentMethod> filteredMethods = ObservableList();

  @observable
  String filteredName = '';

  @observable
  bool areDatesInCrescentOrder = true;

  @observable
  PaymentRecordSortOption sortOption = PaymentRecordSortOption.byName;

  @observable
  bool isCrescentOrder = true;

  ReactionDisposer? _accountReaction;
  ReactionDisposer? _monthReaction;
  ReactionDisposer? _filtersReaction;

  @action
  Future<void> fetch() async {
    if (state is LoadingState) return;

    var accounts = _accountStore.visualizingAccounts;

    var (:month, :year) = _monthStore.month;

    List<PaymentRecord<Paiyable>> records = [];

    state = const LoadingState();

    for (var account in accounts) {
      var result = await _get(account: account, month: month, year: year);

      if (result.isError()) {
        state = FailState(result.exceptionOrNull()!);
        return;
      }

      records.addAll(result.getOrDefault([]));
    }

    var map = _transformToMap(records);

    state = SuccessState(map);
  }

  @action
  void filter() {
    if (state is! SuccessState) return;

    var filtered = _filterRecords();

    filteredState = ObservableMap.of(_transformToMap(filtered, 'filtering'));
  }

  @action
  void setOriginFilter(PaymentRecordType? type) {
    filteredOrigin = type;
  }

  @action
  void setNameFilter(String? name) {
    filteredName = name ?? '';
  }

  @action
  void setSortOption(PaymentRecordSortOption option) {
    sortOption = option;
  }

  @action
  void setDatesCrescentOrder(bool crescentOrder) {
    areDatesInCrescentOrder = crescentOrder;
  }

  @action
  void toggleCrescentOrder() {
    isCrescentOrder = !isCrescentOrder;
  }

  @action
  void togglePaymentMethod(PaymentMethod method) {
    filteredMethods.contains(method)
        ? filteredMethods.remove(method)
        : filteredMethods.add(method);
  }

  @action
  void setMinValue(double value) {
    minValueRange = value;
  }

  @action
  void setMaxValue(double value) {
    maxValueRange = value;
  }

  @action
  void setMinDate(Date date) {
    firstDateRange = date;
  }

  @action
  void setMaxDate(Date date) {
    lastDateRange = date;
  }

  @action
  void activate() {
    if (_accountReaction != null && _monthReaction != null) return;

    _accountReaction = reaction(
      (_) => _accountStore.state,
      (_) {
        if (_accountStore.state is! SuccessState) {
          state = const InitialState();
          return;
        }

        state = const SuccessState({});

        fetch();
      },
    );

    _monthReaction = reaction((_) => _monthStore.month, (_) {
      state = const SuccessState({});

      setMinDate(firstDateRange.copyWith(
        month: _monthStore.month.month,
        year: _monthStore.month.year,
      ));

      setMaxDate(lastDateRange.copyWith(
        month: _monthStore.month.month,
        year: _monthStore.month.year,
      ));

      fetch();
    });

    _filtersReaction = reaction((_) => state, (_) {
      if (state is SuccessState) filter();
    });
  }

  @action
  deactivate() {
    state = const InitialState();

    filteredState.clear();
    filteredMethods.clear();
    filteredOrigin = null;
    filteredName = '';

    isCrescentOrder = true;
    sortOption = PaymentRecordSortOption.byName;

    areDatesInCrescentOrder = false;

    var today = Date.today();
    firstDateRange = today.copyWith(day: 1);
    lastDateRange = today.copyWith(day: today.totalDaysOfMonth);

    minValueRange = 0.00;
    maxValueRange = 0.00;

    _accountReaction?.call();
    _accountReaction = null;

    _monthReaction?.call();
    _monthReaction = null;

    _filtersReaction?.call();
    _filtersReaction = null;
  }

  Map<int, List<PaymentRecord<Paiyable>>> _transformToMap(
      List<PaymentRecord> records,
      [String name = 'fetching']) {
    var mapped = records.fold(
      <int, List<PaymentRecord<Paiyable>>>{},
      (oldMap, record) {
        var map = oldMap
          ..update(
            record.date.day,
            (list) => [...list, record],
            ifAbsent: () => [record],
          );

        return map;
      },
    );

    return mapped;
  }

  List<PaymentRecord<Paiyable>> _filterRecords() {
    if (state is! SuccessState<Map<int, List<PaymentRecord<Paiyable>>>>) {
      return [];
    }

    var map =
        (state as SuccessState<Map<int, List<PaymentRecord<Paiyable>>>>).state;

    List<PaymentRecord> list = [];
    for (var records in map.values) {
      list.addAll(List.from(records)); // Criação de cópias das listas
    }

    list = _filter.byType(records: list, type: filteredOrigin);

    list = _filter.byName(records: list, name: filteredName);

    list = _filter.byPaymentMethods(
        records: list, paymentMethods: filteredMethods);

    list = _filter.byDateRange(
        records: list, minDate: firstDateRange, maxDate: lastDateRange);

    list = _filter.byValueRange(
        records: list, minValue: minValueRange, maxValue: maxValueRange);

    list = switch (sortOption) {
      PaymentRecordSortOption.byName =>
        _sort.byName(records: list, isCrescent: isCrescentOrder),
      PaymentRecordSortOption.byValue =>
        _sort.byValue(records: list, isCrescent: isCrescentOrder),
      PaymentRecordSortOption.byPaymentDate =>
        _sort.byPaymentDate(records: list, isCrescent: isCrescentOrder),
    };

    return list;
  }
}
