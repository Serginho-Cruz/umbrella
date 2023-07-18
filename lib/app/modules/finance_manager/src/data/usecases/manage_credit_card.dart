import 'package:result_dart/result_dart.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/usecases/imanage_credit_card.dart';
import '../../errors/errors.dart';
import '../repositories/icredit_card_repository.dart';

class ManageCreditCard implements IManageCreditCard {
  final ICreditCardRepository repository;

  ManageCreditCard(this.repository);

  @override
  Future<Result<void, Fail>> cancel(CreditCard card) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<List<CreditCard>, Fail>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> register(CreditCard card) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> update(CreditCard newCard) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
