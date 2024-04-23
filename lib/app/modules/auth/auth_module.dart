import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/controllers/auth_controller.dart';

import '../core/core_module.dart';
import 'src/presenter/controllers/user_controller.dart';
import 'src/presenter/screens/login_screen.dart';

class AuthModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void exportedBinds(Injector i) {
    i.addSingleton(AuthController.new);
    i.addSingleton(UserController.new);
    super.exportedBinds(i);
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);
    r.child('/', child: (context) => const LoginScreen());
  }
}

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/auth/');
  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    var result = await Modular.get<AuthController>().isUserInLocal();
    return result;
  }
}
