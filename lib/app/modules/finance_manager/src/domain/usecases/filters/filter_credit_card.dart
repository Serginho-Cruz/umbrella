import '../../entities/credit_card.dart';

abstract interface class FilterCreditCard {
  List<CreditCard> byName(List<CreditCard> cards, String name);
}
