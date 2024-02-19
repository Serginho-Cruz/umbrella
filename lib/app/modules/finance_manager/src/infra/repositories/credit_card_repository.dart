import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/icredit_card_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../datasources/icredit_card_datasource.dart';

class CreditCardRepository implements ICreditCardRepository {
  final ICreditCardDatasource creditCardDatasource;

  CreditCardRepository({
    required this.creditCardDatasource,
  });

  @override
  Future<Result<int, Fail>> create(CreditCard card) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> updateCard(CreditCard newCard) {
    // TODO: implement updateCard
    throw UnimplementedError();
  }

  @override
  Future<Result<List<CreditCard>, Fail>> getAll() async {
    List<CreditCard> cards;
    try {
      cards = await creditCardDatasource.getAll();
    } on Fail catch (fail) {
      return Failure(fail);
    } catch (exception) {
      return Failure(GenericError());
    }

    return Success(cards);
  }

  @override
  Future<Result<void, Fail>> delete(CreditCard card) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
