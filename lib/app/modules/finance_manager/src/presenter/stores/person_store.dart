import 'package:mobx/mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/obtain_persons_debts.dart';

import '../../domain/models/expense_model.dart';
import '../../domain/models/income_model.dart';
import '../../domain/states/state.dart';
import '../../domain/usecases/gets/get_persons.dart';
import '../../errors/errors.dart';
import 'expense_store.dart';
import 'income_store.dart';
part 'person_store.g.dart';

class PersonStore = _PersonStoreBase with _$PersonStore;

abstract class _PersonStoreBase with Store {
  final GetPersons _get;
  final ObtainPersonsDebts _obtainDebts;
  final ExpenseStore _expenseStore;
  final IncomeStore _incomeStore;

  _PersonStoreBase({
    required GetPersons get,
    required ObtainPersonsDebts obtainDebts,
    required ExpenseStore expenseStore,
    required IncomeStore incomeStore,
  })  : _get = get,
        _obtainDebts = obtainDebts,
        _expenseStore = expenseStore,
        _incomeStore = incomeStore;

  @observable
  State<Map<String, double>> personsDebts = const InitialState();

  ObservableList<String> personNames = ObservableList();

  ReactionDisposer? _incomesReaction;
  ReactionDisposer? _expensesReaction;

  void activate() {
    _incomesReaction = reaction((_) => _incomeStore.state, (_) {
      obtainPersonsDebts();
    });

    _expensesReaction = reaction((_) => _expenseStore.state, (_) {
      obtainPersonsDebts();
    });

    obtainPersonsDebts();
  }

  void deactivate() {
    _incomesReaction?.call();
    _expensesReaction?.call();
  }

  @action
  Future<void> getAll() async {
    var names = await _get();

    personNames.clear();
    personNames.addAll(names);
  }

  @action
  Future<void> obtainPersonsDebts() async {
    var incomeState = _incomeStore.state;
    var expenseState = _expenseStore.state;

    if (incomeState is FailState) {
      personsDebts = const FailState(Fail(
          'Algum problema ocorreu ao buscar as receitas do mês. Por favor, tente atualizar a tela'));
      return;
    }

    if (expenseState is FailState) {
      personsDebts = const FailState(Fail(
          'Algum problema ocorreu ao buscar as despesas do mês. Por favor, tente atualizar a tela'));
      return;
    }

    if (expenseState is LoadingState || incomeState is LoadingState) {
      personsDebts = const LoadingState();
      return;
    }

    personsDebts = const LoadingState();

    var incomes = (incomeState as SuccessState<List<IncomeModel>>).state;
    var expenses = (expenseState as SuccessState<List<ExpenseModel>>).state;

    var debts = await _obtainDebts(
      expenseModels: expenses,
      incomeModels: incomes,
    );

    personsDebts = SuccessState(debts);
  }
}
