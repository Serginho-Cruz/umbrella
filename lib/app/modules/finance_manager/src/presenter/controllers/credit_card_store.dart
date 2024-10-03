import 'package:flutter_triple/flutter_triple.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user_state.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/stores/auth_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/manage_credit_card.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/usecases/filters/filter_credit_card.dart';
import '../../errors/errors.dart';

class CreditCardStore extends Store<List<CreditCard>> {
  CreditCardStore({
    required ManageCreditCard manageCreditCard,
    required AuthStore authStore,
    required FilterCreditCard filterCards,
  })  : _manageCreditCard = manageCreditCard,
        _authStore = authStore,
        _filterCards = filterCards,
        super([]);

  final ManageCreditCard _manageCreditCard;
  final AuthStore _authStore;
  final FilterCreditCard _filterCards;

  bool _hasAll = false;
  List<CreditCard> all = [];

  AsyncResult<String, Fail> register(CreditCard card) async {
    var result = await _manageCreditCard.register(
      card,
      (_authStore.state as SuccessState).user,
    );

    if (result.isSuccess()) _hasAll = false;
    return result;
  }

  AsyncResult<Unit, Fail> updateCard(
    CreditCard oldCard,
    CreditCard newCard,
  ) async {
    var result = await _manageCreditCard.update(oldCard, newCard);

    if (result.isSuccess()) _hasAll = false;

    return result;
  }

  Future<void> getAll() async {
    if (_hasAll || isLoading) return;

    if (_authStore.state is! SuccessState) return;

    setLoading(true);

    var result =
        await _manageCreditCard.getAll((_authStore.state as SuccessState).user);

    result.fold((cards) {
      update(cards, force: true);
      _hasAll = true;
      all
        ..clear()
        ..addAll(cards);
    }, (error) {
      all.clear();
      setError(error);
    });

    setLoading(false);
  }

  void filterByName(String name) {
    update(_filterCards.byName(all, name));
  }
}
