import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/external/user_mapper.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/back4app/mappers/credit_card_mapper.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/back4app/parse_objects.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/credit_card_datasource.dart';

import '../functions.dart';
import '../mappers/account_mapper.dart';

class Back4AppCreditCardDatasource implements CreditCardDatasource {
  @override
  Future<String> create(CreditCard card, User user) async {
    var parseUser = UserMapper.toParse(user);

    var object =
        CreditCardMapper.toParse(card, parseUser: parseUser, noId: true)
          ..setACL(ParseACL(owner: parseUser));

    var response = await object.create();

    if (isResponseSuccesful(response)) {
      return (response.results!.first as ParseObject).objectId!;
    }

    throw extractFail(response);
  }

  @override
  Future<void> update(CreditCard newCard) async {
    var object = CreditCardMapper.toParse(newCard);

    var response = await object.update();

    if (isResponseSuccesful(response)) {
      return;
    }

    throw extractFail(response);
  }

  @override
  Future<List<CreditCard>> getAll(User user) async {
    var parseUser = UserMapper.toParse(user);

    var query = QueryBuilder(CreditCardObject());

    query.whereEqualTo('user', parseUser);
    query.includeObject(['account']);

    var response = await query.query();

    if (isResponseSuccesful(response)) {
      var objects = response.results as List<ParseObject>?;

      if (objects == null) return [];

      return objects.map((object) {
        var account = AccountMapper.fromParse(object.get('account'));
        return CreditCardMapper.fromParse(object, account: account);
      }).toList();
    }

    throw extractFail(response);
  }

  @override
  Future<void> delete(CreditCard card) async {
    var object = CreditCardMapper.toParse(card);

    object.set('isDeleted', true);

    var response = await object.save();

    if (isResponseSuccesful(response)) {
      return;
    }

    throw extractFail(response);
  }
}
