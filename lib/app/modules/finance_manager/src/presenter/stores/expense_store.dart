import 'package:mobx/mobx.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/round.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/frequency.dart';
import '../../domain/entities/payment_record.dart';
import '../../domain/models/expense_model.dart';
import '../../domain/models/status.dart';
import '../../domain/states/state.dart';
import '../../domain/usecases/filters/filter_expenses.dart';
import '../../domain/usecases/manage_expense.dart';
import '../../domain/usecases/pay_expense.dart';
import '../../domain/usecases/sorts/sort_expenses.dart';
import '../../domain/usecases/validates/validate_expense.dart';
import '../../errors/errors.dart';
import 'account_store.dart';
import 'finance_filterable_store.dart';
import 'month_store.dart';
import 'paiyable_store.dart';
part 'expense_store.g.dart';

class ExpenseStore = _ExpenseStoreBase with _$ExpenseStore;

abstract class _ExpenseStoreBase
    with Store
    implements FinanceFilterableStore, PaiyableStore<ExpenseModel, Expense> {
  final MonthStore _monthStore;
  final AccountStore _accountStore;
  final ManageExpense _manageExpense;
  final FilterExpenses _filterExpenses;
  final SortExpenses _sortExpenses;
  final PayExpense _payExpense;
  final ValidateExpense _validateExpense;

  _ExpenseStoreBase({
    required MonthStore monthStore,
    required AccountStore accountStore,
    required ManageExpense manageExpense,
    required FilterExpenses filterExpenses,
    required SortExpenses sortExpenses,
    required PayExpense payExpense,
    required ValidateExpense validateExpense,
  })  : _monthStore = monthStore,
        _accountStore = accountStore,
        _manageExpense = manageExpense,
        _filterExpenses = filterExpenses,
        _sortExpenses = sortExpenses,
        _payExpense = payExpense,
        _validateExpense = validateExpense {
    _setUpReactions();
  }

  late final ReactionDisposer _filteredExpensesUpdater;
  late final ReactionDisposer _accountsReaction;
  late final ReactionDisposer _monthReaction;

  @observable
  State<List<ExpenseModel>> state = const InitialState();

  @override
  @computed
  bool get isLoading => state is LoadingState;

  ObservableList<ExpenseModel> filteredExpenses = ObservableList();

  @override
  ObservableList<PaymentRecord<Expense>> paymentsToDo = ObservableList();

  @override
  ObservableList<PaymentMethod> remainingMethods = ObservableList()
    ..addAll(PaymentMethod.all);

  ///This observable stores the [ExpenseModel] selected to edit, delete or pay.
  @observable
  ExpenseModel? selectedModel;

  @override
  @computed
  bool get wasFiltered {
    if (filteredCategories.isNotEmpty) return true;
    if (filteredStatus.isNotEmpty) return true;
    if (filteredName.isNotEmpty) return true;
    if (filteredRangeValue != minAndMax) return true;

    return false;
  }

  @computed
  double get totalToPay => filteredExpenses.fold(
        0.00,
        (v, expense) => (v + expense.totalValue).roundToDecimal(),
      );

  @computed
  double get totalPaid => filteredExpenses.fold(
        0.00,
        (v, expense) => (v + expense.paidValue).roundToDecimal(),
      );

  @override
  @computed
  double get totalPaying => paymentsToDo.fold(
      0.00, (v, record) => (v + record.value).roundToDecimal());

  @override
  @computed
  ({double min, double max}) get minAndMax {
    if (state is! SuccessState<List<ExpenseModel>>) {
      return (min: 0.00, max: 0.00);
    }

    var list = (state as SuccessState<List<ExpenseModel>>).state;

    if (list.isEmpty) return (min: 0.00, max: 0.00);

    list.sort(
        (model1, model2) => model1.totalValue.compareTo(model2.totalValue));

    return (min: list.first.totalValue, max: list.last.totalValue);
  }

  @override
  ObservableList<Category> filteredCategories = ObservableList();

  @override
  ObservableList<Status> filteredStatus = ObservableList();

  @override
  @observable
  String filteredName = '';

  @override
  @observable
  ({double min, double max}) filteredRangeValue = (min: 0.00, max: 0.00);

  @override
  @observable
  PaiyableSortOption sortOption = PaiyableSortOption.byDueDate;

  @override
  @observable
  bool isCrescentOrder = true;

  @observable
  String name = '';

  @observable
  double value = 0.00;

  @override
  @observable
  Account? account;

  @observable
  Frequency frequency = Frequency.none;

  @observable
  Category? category;

  @observable
  Date dueDate = Date.today();

  @observable
  String? personName;

  @observable
  CreditCard? card;

  final String _selectedForUpdateError =
      'Despesa para atualizar não selecionada';

  @action
  Future<Fail?> register() async {
    String? error = _validateFields();

    if (error != null) return Fail(error);

    state = const LoadingState();

    var result = await _manageExpense.register(_mountExpense());

    return result.fold((_) {
      getAll(ignoreLoading: true);
      return null;
    }, (fail) {
      state = FailState(fail);
      return fail;
    });
  }

  @action
  Future<Fail?> edit() async {
    if (selectedModel == null) return Fail(_selectedForUpdateError);

    String? error = _validateFields();

    if (error != null) return Fail(error);

    state = const LoadingState();

    var expense = selectedModel!.toEntity();

    var result = await _manageExpense.update(
      newExpense: _mountExpense(based: expense),
      oldExpense: expense,
    );

    return result.fold((_) {
      getAll(ignoreLoading: true);
      return null;
    }, (fail) {
      state = FailState(fail);
      return fail;
    });
  }

  @override
  @action
  Future<Fail?> switchAccount() async {
    if (selectedModel == null) return Fail(_selectedForUpdateError);

    String? error = _validateExpense.validateAccount(account);
    if (error != null) return Fail(error);

    if (account == selectedModel?.account) return null;

    state = const LoadingState();

    var result =
        await _manageExpense.switchAccount(selectedModel!.toEntity(), account!);

    return result.fold((_) {
      getAll(ignoreLoading: true);
      return null;
    }, (fail) {
      state = FailState(fail);
      return fail;
    });
  }

  @override
  @action
  Future<Fail?> updateValue() async {
    if (selectedModel == null) return Fail(_selectedForUpdateError);

    String? error = _validateExpense.validateValue(value);
    if (error != null) return Fail(error);

    if (value == selectedModel?.totalValue) return null;

    state = const LoadingState();

    var result = await _manageExpense.updateValue(
      selectedModel!.toEntity(),
      value,
    );

    return result.fold((_) {
      getAll(ignoreLoading: true);
      return null;
    }, (fail) {
      state = FailState(fail);
      return fail;
    });
  }

  ///Fetches all Expenses of the month. If [ignoreLoading] is set to true, the
  ///data will be fetched even in the case state is being loaded.
  @action
  Future<void> getAll({bool ignoreLoading = false}) async {
    if (state is LoadingState && ignoreLoading == false) return;

    state = const LoadingState();

    List<Account> accountsList = _accountStore.visualizingAccounts;

    var (:year, :month) = _monthStore.month;

    var results = await Future.wait(
      accountsList.map(
        (acc) => _manageExpense.getAllOf(
          month: month,
          year: year,
          account: acc,
        ),
      ),
    );

    if (results.any((res) => res.isError())) {
      Fail fail = results.firstWhere((res) => res.isError()).exceptionOrNull()!;
      state = FailState(fail);
      return;
    }

    List<Expense> incomes = results.fold([], _appendExpensesFromResult);

    var models = incomes.map(_toModel).toList();

    state = SuccessState(models);
  }

  @override
  @action
  Future<Fail?> pay() async {
    if (paymentsToDo.isEmpty) return null;

    state = const LoadingState();

    paymentsToDo.removeWhere((rec) => rec.value == 0.00);

    for (var payment in paymentsToDo) {
      var result = await _payExpense.withoutCredit(payment);

      if (result.isError()) {
        state = FailState(result.exceptionOrNull()!);
        return result.exceptionOrNull();
      }
    }

    state = const InitialState();
    _accountStore.get(force: true);
    return null;
  }

  @override
  @action
  void toggleCategory(Category category) {
    filteredCategories.contains(category)
        ? filteredCategories.remove(category)
        : filteredCategories.add(category);
  }

  @override
  @action
  void toggleStatus(Status status) {
    filteredStatus.contains(status)
        ? filteredStatus.remove(status)
        : filteredStatus.add(status);
  }

  @override
  @action
  void setFilterName(String name) {
    filteredName = name;
  }

  @override
  @action
  void setMinValueRange(double min) {
    if (min < 0.00) return;

    var max = filteredRangeValue.max;

    filteredRangeValue = (min: min, max: max);
  }

  @override
  @action
  void setMaxValueRange(double max) {
    if (max > minAndMax.max) return;
    var min = filteredRangeValue.min;

    filteredRangeValue = (min: min, max: max);
  }

  @override
  @action
  void setSortOption(PaiyableSortOption? option) =>
      sortOption = option ?? PaiyableSortOption.byDueDate;

  @override
  @action
  void toggleCrescentOrder() => isCrescentOrder = !isCrescentOrder;

  @override
  @action
  void clearFilters() {
    filteredCategories.clear();
    filteredStatus.clear();
    filteredRangeValue = (min: 0.00, max: 0.00);
    sortOption = PaiyableSortOption.byDueDate;
    isCrescentOrder = true;
  }

  @override
  @action
  void addPayment({required PaymentMethod method, required Account account}) {
    if (selectedModel == null) return;

    var newRecord = PaymentRecord(
      id: '',
      usedAccount: account,
      paiyable: selectedModel!.toEntity(),
      paymentMethod: method,
      value: 0.00,
      date: Date.today(),
    );

    paymentsToDo.add(newRecord);
    remainingMethods.remove(method);
  }

  @override
  @action
  void removePayment(PaymentMethod method) {
    paymentsToDo.removeWhere((rec) => rec.paymentMethod == method);
    remainingMethods.add(method);
  }

  @override
  @action
  void setPaymentAccount({
    required PaymentMethod method,
    required Account account,
  }) {
    int index = paymentsToDo.indexWhere((rec) => rec.paymentMethod == method);

    if (index == -1) return;

    paymentsToDo[index] = paymentsToDo[index].copyWith(usedAccount: account);
  }

  @override
  @action
  void setPaymentCreditCard(CreditCard? card) {
    this.card = card;
  }

  @override
  @action
  void setPaymentValue({
    required PaymentMethod method,
    required double value,
  }) {
    int index = paymentsToDo.indexWhere((rec) => rec.paymentMethod == method);

    if (index == -1) return;

    paymentsToDo[index] = paymentsToDo[index].copyWith(value: value);
  }

  @override
  @action
  void filter() {
    if (state is! SuccessState<List<ExpenseModel>>) return;

    var models = (state as SuccessState<List<ExpenseModel>>).state;

    models = _filterExpenses.byName(models: models, searchName: filteredName);

    models = _filterExpenses.byCategory(
      models: models,
      categories: filteredCategories,
    );

    var filteredMin = filteredRangeValue.min;
    var filteredMax = filteredRangeValue.max;

    var (:min, :max) = minAndMax;

    if (filteredMin == 0.00 && filteredMax == 0.00) {
      filteredRangeValue = minAndMax;
    }

    if (filteredRangeValue.max > max) {
      filteredRangeValue = (min: filteredRangeValue.min, max: max);
    }

    (:min, :max) = filteredRangeValue;

    models = _filterExpenses.byRangeValue(models: models, min: min, max: max);

    models = _filterExpenses.byStatus(models: models, status: filteredStatus);

    models = _sort(models);

    filteredExpenses.clear();
    filteredExpenses.addAll(models);
  }

  @override
  List<PaymentMethod> get allowedMethods => PaymentMethod.all;

  @override
  @action
  void restartPayments() {
    paymentsToDo.clear();
    remainingMethods
      ..clear()
      ..addAll(allowedMethods);
  }

  @action
  void setSelectedModel(ExpenseModel? model) => selectedModel = model;

  @action
  void setName(String? name) => this.name = name ?? '';

  @override
  @action
  void setValue(double value) => this.value = value;

  @override
  @action
  void setAccount(Account? account) => this.account = account;

  @action
  void setFrequency(Frequency frequency) => this.frequency = frequency;

  @action
  void setCategory(Category? category) => this.category = category;

  @action
  void setDueDate(Date date) => dueDate = date;

  @action
  void setPersonName(String? personName) => this.personName =
      personName == null || personName.isEmpty ? null : personName;

  @override
  String? validateAccount(Account? _) =>
      _validateExpense.validateAccount(account);

  String? validateName(String? _) => _validateExpense.validateName(name);

  @override
  String? validateValue(_) => _validateExpense.validateValue(value);

  String? validateDueDate(_) => _validateExpense.validateDueDate(dueDate);

  String? validateCategory(_) => _validateExpense.validateCategory(category);

  String? validatePersonName(String? _) =>
      _validateExpense.validatePersonName(personName);

  void dispose() {
    _filteredExpensesUpdater();
    _accountsReaction();
    _monthReaction();
  }

  void _setUpReactions() {
    _filteredExpensesUpdater = reaction((_) => state, (state) {
      if (state is! SuccessState) {
        clearFilters();
        return;
      }

      filter();
    });

    _monthReaction = reaction((_) => _monthStore.month, (_) => getAll());

    _accountsReaction = reaction(
      (_) => _accountStore.visualizingAccounts.iterator,
      (_) => getAll(ignoreLoading: true),
    );
  }

  List<ExpenseModel> _sort(List<ExpenseModel> list) {
    var func = switch (sortOption) {
      PaiyableSortOption.byName => _sortExpenses.byName,
      PaiyableSortOption.byValue => _sortExpenses.byValue,
      PaiyableSortOption.byDueDate => _sortExpenses.byDueDate,
    };

    return func(list, isCrescent: isCrescentOrder);
  }

  ///Mounts an Expense. This method may be called just once
  ///all fields are valid, an error can be thrown otherwise.
  Expense _mountExpense({Expense? based}) {
    return Expense(
      id: based?.id ?? '',
      name: name,
      totalValue: value,
      paidValue: based?.paidValue ?? 0.00,
      remainingValue: based?.remainingValue ?? value,
      dueDate: dueDate,
      account: account!,
      frequency: frequency,
      category: category!,
      personName: based?.personName ?? personName,
    );
  }

  String? _validateFields() => _validateExpense.validateAll(
        account: account,
        name: name,
        value: value,
        dueDate: dueDate,
        personName: personName,
        category: category,
      );

  List<Expense> _appendExpensesFromResult(
    List<Expense> list,
    Result<List<Expense>, Fail> res,
  ) =>
      list..addAll(res.getOrDefault([]));

  ExpenseModel _toModel(Expense i) {
    return ExpenseModel.fromExpense(i, status: _determineStatus(i));
  }

  Status _determineStatus(Expense i) {
    if (i.remainingValue == 0.00) return Status.okay;

    if (i.dueDate.isBefore(Date.today())) {
      return Status.overdue;
    }

    return Status.inTime;
  }
}
