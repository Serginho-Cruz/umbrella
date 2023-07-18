import '../entities/credit_card.dart';

abstract class ISearchCard {
  List<CreditCard> byName({
    required List<CreditCard> cards,
    required String searchString,
  });
}
