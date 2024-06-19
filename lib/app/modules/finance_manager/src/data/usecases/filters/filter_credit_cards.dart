import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';

import '../../../domain/usecases/filters/filter_credit_card.dart';

class FilterCreditCardsImpl implements FilterCreditCard {
  @override
  List<CreditCard> byName(List<CreditCard> cards, String name) {
    return name.isEmpty
        ? cards
        : cards
            .where(
                (card) => card.name.toLowerCase().contains(name.toLowerCase()))
            .toList();
  }
}
