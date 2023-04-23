import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/credit_card.dart';

abstract class IMaintainCreditCard {
  Result<void, Fail> register(CreditCard card);
  Result<void, Fail> update(CreditCard newCard);
  Result<List<CreditCard>, Fail> getAll();
  Result<void, Fail> delete(CreditCard card);
}
