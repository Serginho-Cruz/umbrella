// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_triple/flutter_triple.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/manage_local_user.dart';
import '../../domain/usecases/manage_user.dart';

class UserController extends Store<User?> {
  final ManageUser _manageUser;
  final ManageLocalUser _manageLocalUser;

  UserController({
    required ManageUser manageUser,
    required ManageLocalUser manageLocalUser,
  })  : _manageUser = manageUser,
        _manageLocalUser = manageLocalUser,
        super(null) {
    searchLocally();
  }

  Future<({bool hasError, String error})> register(User newUser) async {
    var result = await _manageUser.register(newUser);

    if (result.isError()) {
      return (hasError: true, error: result.exceptionOrNull()!.message);
    }

    return (hasError: false, error: "Usuário criado com sucesso");
  }

  Future<void> setInLocal(User user) async {
    _manageLocalUser.storeInLocal(user);
  }

  Future<User?> searchLocally() async {
    var result = await _manageLocalUser.getInLocal();

    update(result.getOrNull());
    return result.getOrNull();
  }
}
