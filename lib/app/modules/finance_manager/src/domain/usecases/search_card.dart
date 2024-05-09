import '../entities/credit_card.dart';

abstract interface class SearchCard {
  List<CreditCard> byName({
    required List<CreditCard> cards,
    required String searchString,
  });
}
