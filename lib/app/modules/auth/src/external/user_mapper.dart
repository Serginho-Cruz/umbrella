import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../domain/entities/user.dart';

sealed class UserMapper {
  ///Transform a [User] instance to a [ParseUser] instance.
  ///
  ///Use [toParseFrom] instead on a login scenario.
  static ParseUser toParse(User user) {
    var parse = ParseUser(
      user.email,
      user.password,
      user.email,
      sessionToken: user.token,
    );
    return parse
      ..set('name', user.name)
      ..objectId = user.id;
  }

  ///Returns a [ParseUser] instance using the [email] and [password] credentials
  static ParseUser toParseFrom({
    required String email,
    required String password,
  }) {
    return ParseUser(email, password, email);
  }

  ///Transform a [ParseUser] instance to a [User] instance.
  ///
  ///NOTE: Don't use this conversion in scenarios where [ParseUser] has no [objectId].
  static User fromParse(ParseUser parseUser) {
    return User(
      id: parseUser.objectId!,
      name: parseUser.get('name'),
      email: parseUser.emailAddress!,
      password: parseUser.password ?? '',
      token: parseUser.sessionToken,
    );
  }
}
