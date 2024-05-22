import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';

abstract interface class CreditCardDatasource {
  Future<int> create(CreditCard card, User user);
  Future<void> update(CreditCard newCard);
  Future<List<CreditCard>> getAll(User user);
  Future<void> delete(CreditCard card);
}
