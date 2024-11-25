import 'package:mobx/mobx.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/stores/auth_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/states/state.dart';

import '../../../../auth/src/domain/entities/user_state.dart' as u;
import '../../domain/entities/account.dart';
import '../../domain/entities/credit_card.dart';
import '../../domain/usecases/filters/filter_credit_card.dart';
import '../../domain/usecases/manage_credit_card.dart';
import '../../domain/usecases/validates/validate_credit_card.dart';
import '../../errors/errors.dart';
part 'credit_card_store.g.dart';

class CreditCardStore = _CreditCardStoreBase with _$CreditCardStore;

abstract class _CreditCardStoreBase with Store {
  final ValidateCreditCard _validate;
  final ManageCreditCard _manageCreditCard;
  final FilterCreditCard _filterCreditCard;
  final AuthStore _authStore;

  ReactionDisposer? _updateFiltered;
  ReactionDisposer? _searchReaction;

  @observable
  State<List<CreditCard>> state = const InitialState();

  ObservableList<CreditCard> filteredCards = ObservableList();

  @observable
  String searchString = '';

  @observable
  String name = '';

  @observable
  String color = '';

  @observable
  int invoiceCloseDay = 1;

  @observable
  int invoiceDueDay = 10;

  @observable
  Account? account;

  @observable
  bool isUserUnlogged = false;

  @observable
  bool isDataInvalid = false;

  _CreditCardStoreBase({
    required ValidateCreditCard validate,
    required ManageCreditCard manageCreditCard,
    required FilterCreditCard filterCreditCard,
    required AuthStore authStore,
  })  : _validate = validate,
        _manageCreditCard = manageCreditCard,
        _filterCreditCard = filterCreditCard,
        _authStore = authStore {
    _setUpReactions();
  }

  @computed
  bool get showPreview {
    return account != null && color.isNotEmpty && name.isNotEmpty;
  }

  @computed
  bool get isLoading => state is LoadingState;

  @action
  Future<Fail?> register() async {
    if (_areInformationsValid() == false) {
      return const Fail(
          'O formulário contém erros. Corrija-os para cadastrar seu cartão');
    }
    state = const LoadingState();

    final CreditCard card = CreditCard.withoutId(
      name: name,
      color: color,
      cardInvoiceClosingDay: invoiceCloseDay,
      cardInvoiceDueDay: invoiceDueDay,
      accountToDiscountInvoice: account!,
    );

    var result = await _manageCreditCard.register(
      card,
      (_authStore.state as u.SuccessState).user,
    );

    return result.fold((_) {
      getAll(ignoreLoading: true);
      return null;
    }, (f) {
      state = FailState(f);
      return f;
    });
  }

  @action
  Future<Fail?> updateCard(CreditCard oldCard) async {
    if (_areInformationsValid() == false) {
      return const Fail(
          'O formulário contém erros. Corrija-os para cadastrar seu cartão');
    }

    state = const LoadingState();

    final CreditCard newCard = CreditCard(
      id: oldCard.id,
      name: name,
      color: color,
      cardInvoiceClosingDay: invoiceCloseDay,
      cardInvoiceDueDay: invoiceDueDay,
      accountToDiscountInvoice: account!,
    );

    var result = await _manageCreditCard.update(oldCard, newCard);

    return result.fold((_) {
      getAll(ignoreLoading: true);
      return null;
    }, (f) {
      state = FailState(f);
      return f;
    });
  }

  @action
  Future<void> getAll({bool ignoreLoading = false}) async {
    if (_authStore.state is! u.SuccessState ||
        (state is LoadingState && ignoreLoading == false)) return;

    state = const LoadingState();

    User user = (_authStore.state as u.SuccessState).user;
    var result = await _manageCreditCard.getAll(user);

    state = result.fold((c) => SuccessState(c), (f) => FailState(f));
  }

  @action
  void filterByName() {
    if (state is! SuccessState) return;

    var success = state as SuccessState<List<CreditCard>>;

    filteredCards.clear();
    filteredCards.addAll(_filterCreditCard.byName(success.state, searchString));
  }

  String? validateName(String? _) {
    return _validate.validateName(name);
  }

  String? validateAccount(Account? _) {
    return _validate.validateAccount(account);
  }

  @action
  void setSearchString(String text) {
    searchString = text;
  }

  @action
  void setName(String? name) {
    this.name = name ?? '';
  }

  @action
  void setColor(String hex) {
    color = hex;
  }

  @action
  void setCloseDay(int day) {
    invoiceCloseDay = day;
  }

  @action
  void setDueDay(int day) {
    invoiceDueDay = day;
  }

  @action
  void setAccount(Account? acc) {
    account = acc;
  }

  @action
  void resetFields() {
    name = '';
    color = '';
    invoiceCloseDay = 1;
    invoiceDueDay = 10;
  }

  void dispose() {
    resetFields();
    _updateFiltered?.call();
    _searchReaction?.call();
  }

  @action
  bool _areInformationsValid() {
    isDataInvalid = false;
    isUserUnlogged = false;

    if (_authStore.state is! u.SuccessState) {
      isUserUnlogged = true;
      return false;
    }

    if (_validate.validateName(name) != null ||
        _validate.validateAccount(account) != null) {
      isDataInvalid = true;
      return false;
    }

    return true;
  }

  void _setUpReactions() {
    _updateFiltered = reaction((_) => state, (st) {
      if (st is! SuccessState<List<CreditCard>>) return;

      filterByName();
    });

    _searchReaction = reaction((_) => searchString, (s) {
      filterByName();
    });
  }
}
