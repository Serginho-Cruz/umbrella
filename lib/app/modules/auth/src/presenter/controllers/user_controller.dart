// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_triple/flutter_triple.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/manage_local_token.dart';
import '../../domain/usecases/manage_user.dart';

class UserController extends Store<User?> {
  final ManageUser _manageUser;
  final ManageLocalToken _manageLocalToken;

  UserController({
    required ManageUser manageUser,
    required ManageLocalToken manageLocalToken,
  })  : _manageUser = manageUser,
        _manageLocalToken = manageLocalToken,
        super(null);

  Future<({bool hasError, String error})> register(User newUser) async {
    var result = await _manageUser.register(newUser);

    if (result.isError()) {
      return (hasError: true, error: result.exceptionOrNull()!.message);
    }

    return (hasError: false, error: "Usuário criado com sucesso");
  }

  Future<String?> searchLocally() async {
    var result = await _manageLocalToken.getInLocal();

    return result.getOrNull();
  }
}
