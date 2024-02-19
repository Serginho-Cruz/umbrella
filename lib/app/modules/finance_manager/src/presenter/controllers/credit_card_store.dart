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

  Future<void> getAll() async {
    setLoading(true);

    var result = await _manageCreditCard.getAll();

    result.fold((cards) {
      update(cards);
    }, (error) {
      setError(error);
    });

    setLoading(false);
  }
}
