import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/credit_card.dart';

abstract class IMaintainCreditCard {
  Future<Result<void, Fail>> register(CreditCard card);
  Future<Result<void, Fail>> update(CreditCard newCard);
  Future<Result<List<CreditCard>, Fail>> getAll();
  Future<Result<void, Fail>> delete(CreditCard card);
}
