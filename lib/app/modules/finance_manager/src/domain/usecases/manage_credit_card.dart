import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';

import '../../errors/errors.dart';
import '../entities/credit_card.dart';

abstract interface class ManageCreditCard {
  AsyncResult<int, Fail> register(CreditCard card, User user);
  AsyncResult<Unit, Fail> update(CreditCard newCard);
  AsyncResult<List<CreditCard>, Fail> getAll(User user);
  AsyncResult<Unit, Fail> syncCard({
    required CreditCard cardToSync,
    required CreditCard cardToDelete,
  });
  AsyncResult<Unit, Fail> cancel(CreditCard card);
}
