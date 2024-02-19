import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/credit_card_model.dart';

import '../../errors/errors.dart';
import '../entities/credit_card.dart';

abstract class IManageCreditCard {
  Future<Result<void, Fail>> register(CreditCard card);
  Future<Result<void, Fail>> update(CreditCard newCard);
  Future<Result<List<CreditCardModel>, Fail>> getAll();
  Future<Result<void, Fail>> syncCard({
    required CreditCard cardToSync,
    required CreditCard cardToDelete,
  });
  Future<Result<void, Fail>> cancel(CreditCard card);
}
