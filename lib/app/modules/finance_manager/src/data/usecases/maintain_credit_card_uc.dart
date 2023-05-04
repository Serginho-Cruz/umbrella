import 'package:result_dart/src/result.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/icredit_card_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imaintain_credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

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
