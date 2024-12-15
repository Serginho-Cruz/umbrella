import 'package:mobx/mobx.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/manage_income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/sorts/sort_expenses.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/stores/month_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/stores/paiyable_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/round.dart';

import '../../../../bind_service_provider.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/date.dart';
import '../../domain/entities/income.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/payment_record.dart';
import '../../domain/models/income_model.dart';
import '../../domain/models/status.dart';
import '../../domain/states/state.dart';
import '../../domain/usecases/filters/filter_incomes.dart';
import '../../domain/usecases/receive_income.dart';
import '../../domain/usecases/sorts/sort_incomes.dart';
import '../../domain/usecases/validates/validate_income.dart';
import '../../errors/errors.dart';
import 'account_store.dart';
import 'finance_filterable_store.dart';

part 'income_store.g.dart';

class IncomeStore = _IncomeStoreBase with _$IncomeStore;

abstract class _IncomeStoreBase
    with Store
    implements FinanceFilterableStore, PaiyableStore<IncomeModel, Income> {
  final MonthStore _monthStore;
  final AccountStore _accountStore;
  final ManageIncome _manageIncome;
  final FilterIncomes _filterIncomes;
  final SortIncomes _sortIncomes;
  final ReceiveIncome _receiveIncome;
  final ValidateIncome _validateIncome;

  _IncomeStoreBase({
    required MonthStore monthStore,
    required AccountStore accountStore,
    required ManageIncome manageIncome,
    required FilterIncomes filterIncomes,
    required SortIncomes sortIncomes,
    required ReceiveIncome receiveIncome,
    required ValidateIncome validateIncome,
  })  : _manageIncome = manageIncome,
        _filterIncomes = filterIncomes,
        _sortIncomes = sortIncomes,
        _receiveIncome = receiveIncome,
        _validateIncome = validateIncome,
        _accountStore = accountStore,
        _monthStore = monthStore {
    _setUpReactions();
  }

  late final ReactionDisposer _filteredIncomesUpdater;
  late final ReactionDisposer _accountsReaction;
  late final ReactionDisposer _monthReaction;

  @override
  @observable
  State<List<IncomeModel>> state = const InitialState();

  @override
  @computed
  bool get isLoading => state is LoadingState;

  ObservableList<IncomeModel> filteredIncomes = ObservableList();

  @override
  ObservableList<PaymentRecord<Income>> paymentsToDo = ObservableList();

  @override
  ObservableList<PaymentMethod> remainingMethods = ObservableList()
    ..addAll([
      const PaymentMethod.debit(),
      const PaymentMethod.pix(),
      const PaymentMethod.money(),
    ]);

  ///This observable stores the [IncomeModel] selected to update, delete or receive.
  @observable
  IncomeModel? selectedModel;

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
  double get totalToReceive => filteredIncomes.fold(
        0.00,
        (v, income) => (v + income.totalValue).roundToDecimal(),
      );

  @computed
  double get totalReceived => filteredIncomes.fold(
        0.00,
        (v, income) => (v + income.paidValue).roundToDecimal(),
      );

  @override
  @computed
  double get totalPaying => paymentsToDo.fold(
      0.00, (v, record) => (v + record.value).roundToDecimal());

  @override
  @computed
  ({double min, double max}) get minAndMax {
    if (state is! SuccessState<List<IncomeModel>>) {
      return (min: 0.00, max: 0.00);
    }

    var list = (state as SuccessState<List<IncomeModel>>).state;

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

  final String _selectedForUpdateError =
      'Despesa para atualizar não selecionada';

  @action
  Future<Fail?> register() async {
    String? error = _validateFields();

    if (error != null) return Fail(error);

    state = const LoadingState();

    var result = await _manageIncome.register(_mountIncome());

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
    if (selectedModel == null) {
      return const Fail('Receita para Atualizar não selecionada');
    }

    String? error = _validateFields();

    if (error != null) return Fail(error);

    state = const LoadingState();

    var income = selectedModel!.toEntity();

    var result = await _manageIncome.update(
      newIncome: _mountIncome(based: income),
      oldIncome: income,
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

    String? error = _validateIncome.validateAccount(account);
    if (error != null) return Fail(error);

    if (account == selectedModel?.account) return null;

    state = const LoadingState();

    var result =
        await _manageIncome.switchAccount(selectedModel!.toEntity(), account!);

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

    String? error = _validateIncome.validateValue(value);

    if (error != null) return Fail(error);

    if (value == selectedModel?.totalValue) return null;

    state = const LoadingState();

    var result = await _manageIncome.updateValue(
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

  ///Fetches all Incomes of the month. If [ignoreLoading] is set to true, the
  ///data will be fetched even in the case state is being loaded.
  @action
  Future<void> getAll({bool ignoreLoading = false}) async {
    if (state is LoadingState && ignoreLoading == false) return;

    state = const LoadingState();

    var store = BindServiceProvider.get<AccountStore>();

    List<Account> accountsList = store.visualizingAccounts;

    var (:year, :month) = _monthStore.month;

    var results = await Future.wait(
      accountsList.map(
        (acc) => _manageIncome.getAllOf(
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

    List<Income> incomes = results.fold([], _appendIncomesFromResult);

    var models = incomes.map(_toModel).toList();

    state = SuccessState(models);
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
  void filter() {
    if (state is! SuccessState<List<IncomeModel>>) return;

    var models = (state as SuccessState<List<IncomeModel>>).state;

    models = _filterIncomes.byName(models: models, searchName: filteredName);

    models = _filterIncomes.byCategory(
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

    models = _filterIncomes.byRangeValue(models: models, min: min, max: max);

    models = _filterIncomes.byStatus(models: models, status: filteredStatus);

    models = _sort(models);

    filteredIncomes.clear();
    filteredIncomes.addAll(models);
  }

  @override
  @action
  Future<Fail?> delete() async {
    if (selectedModel == null) {
      const fail = Fail('Receita não selecionada');
      state = const FailState(fail);
      return fail;
    }

    IncomeModel model = selectedModel!;

    Income income = model.toEntity();

    state = const LoadingState();

    var result = await _manageIncome.delete(income);

    return result.fold((_) {
      getAll(ignoreLoading: true);
      return null;
    }, (f) {
      state = FailState(f);
      return f;
    });
  }

  @override
  @action
  Future<Fail?> pay() async {
    if (paymentsToDo.isEmpty) return null;

    state = const LoadingState();

    paymentsToDo.removeWhere((rec) => rec.value == 0.00);

    for (var payment in paymentsToDo) {
      var result = await _receiveIncome(payment);

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
  List<PaymentMethod> get allowedMethods => [
        const PaymentMethod.debit(),
        const PaymentMethod.pix(),
        const PaymentMethod.money(),
      ];

  @override
  void setPaymentCreditCard(CreditCard? card) {}

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
  void restartPayments() {
    paymentsToDo.clear();
    remainingMethods
      ..clear()
      ..addAll(allowedMethods);
  }

  @action
  void setSelectedModel(IncomeModel? model) => selectedModel = model;

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
      _validateIncome.validateAccount(account);

  String? validateName(String? _) => _validateIncome.validateName(name);

  @override
  String? validateValue(_) => _validateIncome.validateValue(value);

  String? validateDueDate(_) => _validateIncome.validateDueDate(dueDate);

  String? validateCategory(_) => _validateIncome.validateCategory(category);

  String? validatePersonName(String? _) =>
      _validateIncome.validatePersonName(personName);

  void dispose() {
    _filteredIncomesUpdater();
    _accountsReaction();
    _monthReaction();
  }

  List<IncomeModel> _sort(List<IncomeModel> list) {
    var func = switch (sortOption) {
      PaiyableSortOption.byName => _sortIncomes.byName,
      PaiyableSortOption.byValue => _sortIncomes.byValue,
      PaiyableSortOption.byDueDate => _sortIncomes.byDueDate,
    };

    return func(list, isCrescent: isCrescentOrder);
  }

  void _setUpReactions() {
    _filteredIncomesUpdater = reaction((_) => state, (state) {
      if (state is! SuccessState) {
        clearFilters();
        return;
      }

      filter();
    });

    _monthReaction = reaction((_) => _monthStore.month, (_) => getAll());

    _accountsReaction = reaction(
        (_) => _accountStore.visualizingAccounts.iterator, (_) => getAll(),
        equals: (_, __) => false);
  }

  ///Mounts an Income. This method may be called just once
  ///all fields are valid, an error can be thrown otherwise.
  Income _mountIncome({Income? based}) {
    return Income(
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

  String? _validateFields() => _validateIncome.validateAll(
        account: account,
        name: name,
        value: value,
        dueDate: dueDate,
        personName: personName,
        category: category,
      );

  List<Income> _appendIncomesFromResult(
    List<Income> list,
    Result<List<Income>, Fail> res,
  ) =>
      list..addAll(res.getOrDefault([]));

  IncomeModel _toModel(Income i) {
    return IncomeModel.fromIncome(i, status: _determineStatus(i));
  }

  Status _determineStatus(Income i) {
    if (i.remainingValue == 0.00) return Status.okay;

    if (i.dueDate.isBefore(Date.today())) {
      return Status.overdue;
    }

    return Status.inTime;
  }
}
