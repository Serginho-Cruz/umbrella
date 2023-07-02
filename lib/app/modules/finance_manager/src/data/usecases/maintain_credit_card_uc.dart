import 'package:result_dart/result_dart.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/usecases/imaintain_credit_card.dart';
import '../../errors/errors.dart';
import '../repositories/icredit_card_repository.dart';

class MaintainCreditCard implements IMaintainCreditCard {
  final ICreditCardRepository repository;

  MaintainCreditCard(this.repository);

  @override
  Future<Result<void, Fail>> register(CreditCard card) =>
      repository.create(card);

  @override
  Future<Result<void, Fail>> update(CreditCard newCard) =>
      repository.updateCard(newCard);

  @override
  Future<Result<List<CreditCard>, Fail>> getAll() => repository.getAll();

  @override
  Future<Result<void, Fail>> delete(CreditCard card) => repository.delete(card);
}
