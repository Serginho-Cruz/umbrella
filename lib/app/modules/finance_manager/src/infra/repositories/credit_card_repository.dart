import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/credit_card_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../datasources/credit_card_datasource.dart';

class CreditCardRepositoryImpl implements CreditCardRepository {
  final ICreditCardDatasource creditCardDatasource;

  CreditCardRepositoryImpl({
    required this.creditCardDatasource,
  });

  @override
  Future<Result<int, Fail>> create(CreditCard card, User user) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Result<Unit, Fail>> update(CreditCard newCard) {
    // TODO: implement updateCard
    throw UnimplementedError();
  }

  @override
  Future<Result<List<CreditCard>, Fail>> getAll(User user) async {
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
  Future<Result<Unit, Fail>> delete(CreditCard card) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
