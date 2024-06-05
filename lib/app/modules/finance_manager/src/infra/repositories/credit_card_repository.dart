import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/credit_card_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../datasources/credit_card_datasource.dart';

class CreditCardRepositoryImpl implements CreditCardRepository {
  final CreditCardDatasource _creditCardDatasource;

  CreditCardRepositoryImpl(this._creditCardDatasource);

  @override
  Future<Result<int, Fail>> create(CreditCard card, User user) async {
    try {
      var id = await _creditCardDatasource.create(card, user);
      return Success(id);
    } on Fail catch (f) {
      return Failure(f);
    } catch (_) {
      return Failure(GenericError());
    }
  }

  @override
  Future<Result<Unit, Fail>> update(CreditCard newCard) async {
    try {
      await _creditCardDatasource.update(newCard);
      return const Success(unit);
    } on Fail catch (f) {
      return Failure(f);
    } catch (_) {
      return Failure(GenericError());
    }
  }

  @override
  Future<Result<List<CreditCard>, Fail>> getAll(User user) async {
    try {
      var cards = await _creditCardDatasource.getAll(user);
      return Success(cards);
    } on Fail catch (fail) {
      return Failure(fail);
    } catch (exception) {
      return Failure(GenericError());
    }
  }

  @override
  Future<Result<Unit, Fail>> delete(CreditCard card) async {
    try {
      await _creditCardDatasource.delete(card);
      return const Success(unit);
    } on Fail catch (f) {
      return Failure(f);
    } catch (_) {
      return Failure(GenericError());
    }
  }
}
