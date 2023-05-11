import 'package:result_dart/result_dart.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/usecases/imaintain_credit_card.dart';
import '../../errors/errors.dart';
import '../repositories/icredit_card_repository.dart';

class MaintainCreditCard implements IMaintainCreditCard {
  final ICreditCardRepository repository;

  MaintainCreditCard(this.repository);

  @override
  Future<Result<void, Fail>> register(CreditCard card) async {
    var result = await repository.create(card);
    return result;
  }

  @override
  Future<Result<void, Fail>> update(CreditCard newCard) async {
    var result = await repository.updateCard(newCard);
    return result;
  }

  @override
  Future<Result<List<CreditCard>, Fail>> getAll() async {
    var result = await repository.getAll();
    return result;
  }

  @override
  Future<Result<void, Fail>> delete(CreditCard card) async {
    var result = await repository.delete(card);
    return result;
  }
}
