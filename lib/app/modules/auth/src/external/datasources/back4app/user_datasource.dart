import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/external/datasources/functions.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/infra/datasources/user_datasource.dart';

import '../../../errors/auth_fail.dart';
import '../../user_mapper.dart';

class Back4AppUserDatasource implements UserDatasource {
  @override
  Future<String> register(User user) async {
    final parseUser = UserMapper.toParse(user);

    final response = await parseUser.signUp();

    if (isResponseSuccesful(response)) {
      var object = (response.results!.first) as ParseObject;
      return object.objectId!;
    }

    throw extractFail(response, returnOn: const {
      ParseError.emailTaken: EmailAlreadyRegistered(),
      ParseError.usernameTaken: EmailAlreadyRegistered(),
      ParseError.duplicateValue: EmailAlreadyRegistered(),
      ParseError.invalidEmailAddress: InvalidEmail(),
    });
  }

  @override
  Future<User> login(String email, String password) async {
    final parseUser = UserMapper.toParseFrom(email: email, password: password);

    final response = await parseUser.login();

    if (isResponseSuccesful(response)) {
      final loggedUser = response.results!.first as ParseUser;
      loggedUser.forgetLocalSession();

      return UserMapper.fromParse(loggedUser);
    }

    throw extractFail(response, returnOn: const {
      ParseError.objectNotFound: IncorrectCredentials(),
    });
  }

  @override
  Future<void> logout(User user) async {
    final parseUser = UserMapper.toParse(user);
    final response = await parseUser.logout();

    if (!isResponseSuccesful(response)) {
      if (response.error?.code == ParseError.invalidSessionToken) {
        await parseUser.logout();
        return;
      }

      throw extractFail(response);
    }
  }

  @override
  Future<void> update(User newUser) async {
    final parseUser = UserMapper.toParse(newUser);

    final response = await parseUser.save();

    if (!isResponseSuccesful(response)) {
      throw extractFail(response, returnOn: const {
        ParseError.emailTaken: EmailAlreadyRegistered(),
        ParseError.usernameTaken: EmailAlreadyRegistered(),
        ParseError.duplicateValue: EmailAlreadyRegistered(),
        ParseError.invalidEmailAddress: InvalidEmail(),
        ParseError.invalidSessionToken: SessionStorageExpired(),
      });
    }
  }

  @override
  Future<void> delete(User user) async {
    final parseUser = UserMapper.toParse(user);

    parseUser.set('isDeleted', true);
    var response = await parseUser.save();

    if (!isResponseSuccesful(response)) {
      throw extractFail(response);
    }
  }

  @override
  Future<User> loginWithToken(String token) async {
    var response = await ParseUser.getCurrentUserFromServer(token);

    if (response == null) throw const GenericAuthFail();

    if (isResponseSuccesful(response)) {
      return UserMapper.fromParse(response.results!.first as ParseUser);
    }

    throw extractFail(response, returnOn: {
      ParseError.invalidSessionToken: const SessionStorageExpired(),
    });
  }
}
