import 'package:flutter_modular/flutter_modular.dart';

import 'user_controller.dart';

class AuthController {
  AuthController();

  Future<bool> isUserInLocal() async {
    var user = await Modular.get<UserController>().searchLocally();

    return user != null;
  }
}
