import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/data/usecases/manage_user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/usecases/manage_user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/external/datasources/back4app/user_datasource.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/external/services/back4app_local_storage.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/infra/repositories/user_repository.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/controllers/auth_controller.dart';

import 'src/data/repositories/user_repository.dart';
import 'src/data/usecases/auth.dart';
import 'src/data/usecases/manage_local_token.dart';
import 'src/domain/usecases/auth.dart';
import 'src/domain/usecases/manage_local_token.dart';
import 'src/infra/datasources/user_datasource.dart';
import 'src/infra/services/local_storage_service.dart';
import 'src/presenter/controllers/user_controller.dart';
import 'src/presenter/screens/login_screen.dart';
import 'src/presenter/screens/register_screen.dart';

class AuthModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addSingleton(
        () => UserController(manageUser: i(), manageLocalToken: i()));
    i.addSingleton(() => AuthController(i(), i()));
    super.exportedBinds(i);
  }

  @override
  void binds(Injector i) {
    super.binds(i);
    i.addLazySingleton<LocalStorageService>(TokenStorage.new);
    i.addLazySingleton<UserDatasource>(Back4AppUserDatasource.new);
    i.addLazySingleton<UserRepository>(
      () => UserRepositoryImpl(
        localStorageService: i(),
        userDatasource: i(),
      ),
    );
    i.addLazySingleton<ManageUser>(() => ManageUserImpl(i()));
    i.addLazySingleton<ManageLocalToken>(() => ManageLocalTokenImpl(i()));
    i.addLazySingleton<Auth>(
        () => AuthImpl(manageLocalToken: i(), repository: i()));
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);
    r.child(
      '/',
      child: (context) => LoginScreen(
        controller: Modular.get<AuthController>(),
      ),
    );
    r.child(
      '/register',
      child: (context) => RegisterScreen(
        controller: Modular.get<UserController>(),
      ),
    );
  }
}

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/auth/');

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    var controller = Modular.get<AuthController>();

    if (controller.isLogged) return true;

    bool isInLocal = await controller.isUserInLocal();

    return isInLocal;
  }
}
