import 'package:result_dart/result_dart.dart';

import '../../domain/entities/credit_card.dart';
import '../../errors/errors.dart';

abstract class ICreditCardRepository {
  Future<Result<void, Fail>> create(CreditCard card);
  Future<Result<void, Fail>> updateCard(CreditCard newCard);
  Future<Result<List<CreditCard>, Fail>> getAll();
  Future<Result<void, Fail>> delete(CreditCard card);
}
