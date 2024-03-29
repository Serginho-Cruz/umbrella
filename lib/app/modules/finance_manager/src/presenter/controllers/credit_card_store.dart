import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imanage_credit_card.dart';
import '../../domain/models/credit_card_model.dart';

class CreditCardStore extends Store<List<CreditCardModel>> {
  CreditCardStore({
    required IManageCreditCard manageCreditCard,
  }) : super([]) {
    _manageCreditCard = manageCreditCard;
  }

  late final IManageCreditCard _manageCreditCard;
  bool hasAll = false;

  Future<void> getAll() async {
    if (hasAll) return;

    setLoading(true);

    var result = await _manageCreditCard.getAll();

    result.fold((cards) {
      update(cards);
      hasAll = true;
    }, (error) {
      setError(error);
    });

    setLoading(false);
  }
}
