import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';

abstract class ICreditCardDatasource {
  Future<int> create(CreditCard card);
  Future<void> update(CreditCard newCard);
  Future<List<CreditCard>> getAll();
  Future<void> delete(CreditCard card);
}
