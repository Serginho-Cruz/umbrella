import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/back4app/parse_objects.dart';

sealed class AccountMapper {
  static ParseObject toParse(
    Account account, {
    ParseUser? parseUser,
    bool noId = false,
  }) {
    var accountObject = AccountObject();

    if (!noId) accountObject.objectId = account.id;
    accountObject.set('name', account.name);
    accountObject.set('isDefault', account.isDefault);
    accountObject.set('actualBalance', account.actualBalance);

    if (parseUser != null) accountObject.set('user', parseUser);

    return accountObject;
  }

  static Account fromParse(ParseObject object) {
    return Account(
      id: object.objectId!,
      name: object.get('name'),
      actualBalance: object.get('actualBalance').toDouble(),
      isDefault: object.get('isDefault'),
    );
  }
}
