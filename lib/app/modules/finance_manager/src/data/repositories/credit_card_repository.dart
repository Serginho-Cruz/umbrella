import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';

import '../../domain/entities/credit_card.dart';
import '../../errors/errors.dart';

abstract interface class CreditCardRepository {
  AsyncResult<int, Fail> create(CreditCard card, User user);
  AsyncResult<Unit, Fail> update(CreditCard newCard);
  AsyncResult<List<CreditCard>, Fail> getAll(User user);
  AsyncResult<Unit, Fail> delete(CreditCard card);
}
