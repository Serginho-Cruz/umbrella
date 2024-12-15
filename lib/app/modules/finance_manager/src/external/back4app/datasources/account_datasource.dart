import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/external/user_mapper.dart';

import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/back4app/mappers/account_mapper.dart';

import '../../../errors/errors.dart';
import '../../../infra/datasources/account_datasource.dart';
import '../functions.dart';
import '../parse_objects.dart';

class Back4AppAccountDatasource implements AccountDatasource {
  @override
  Future<String> create(Account account, User user) async {
    var parseUser = UserMapper.toParse(user);
    var object =
        AccountMapper.toParse(account, parseUser: parseUser, noId: true)
          ..setACL(ParseACL(owner: parseUser));

    var response = await object.create();

    if (isResponseSuccesful(response)) {
      return (response.results!.first as ParseObject).objectId!;
    }

    throw extractFail(response);
  }

  @override
  Future<void> update(Account newAccount) async {
    var object = AccountMapper.toParse(newAccount);

    var response = await object.update();

    if (isResponseSuccesful(response)) {
      return;
    }

    throw extractFail(response);
  }

  @override
  Future<List<Account>> getAllOf(User user) async {
    var parseUser = UserMapper.toParse(user);

    var query = QueryBuilder(AccountObject());

    query.whereEqualTo('user', parseUser.toPointer());
    query.whereEqualTo('isDeleted', false);

    var response = await query.query();

    if (isResponseSuccesful(response)) {
      var objects = response.results as List<ParseObject>?;

      if (objects == null) {
        throw const UserHasntAccounts();
      }

      return objects.map((object) => AccountMapper.fromParse(object)).toList();
    }

    throw extractFail(response);
  }

  @override
  Future<void> delete(Account account) async {
    var object = AccountMapper.toParse(account);

    object.set('isDeleted', true);

    var response = await object.update();

    if (isResponseSuccesful(response)) {
      return;
    }

    throw extractFail(response);
  }
}
