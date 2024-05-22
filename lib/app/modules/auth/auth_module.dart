import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/data/usecases/manage_user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/usecases/manage_user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/external/datasources/user_temporary_datasource.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/external/services/shared_preferences_storage.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/infra/repositories/user_repository.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/controllers/auth_controller.dart';

import 'src/data/repositories/user_repository.dart';
import 'src/data/usecases/auth.dart';
import 'src/data/usecases/manage_local_user.dart';
import 'src/domain/usecases/auth.dart';
import 'src/domain/usecases/manage_local_user.dart';
import 'src/infra/datasources/user_datasource.dart';
import 'src/infra/services/local_storage_service.dart';
import 'src/presenter/controllers/user_controller.dart';
import 'src/presenter/screens/login_screen.dart';
import 'src/presenter/screens/register_screen.dart';

class AuthModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addSingleton(() => UserController(manageUser: i(), manageLocalUser: i()));
    i.addSingleton(() => AuthController(i(), i()));
    super.exportedBinds(i);
  }

  @override
  void binds(Injector i) {
    super.binds(i);
    i.addLazySingleton<LocalStorageService>(SharedPreferencesStorage.new);
    i.addLazySingleton<UserDatasource>(UserTemporaryDatasource.new);
    i.addLazySingleton<UserRepository>(
      () => UserRepositoryImpl(
        localStorageService: i(),
        userDatasource: i(),
      ),
    );
    i.addLazySingleton<Auth>(() => AuthImpl(i()));
    i.addLazySingleton<ManageUser>(() => ManageUserImpl(i()));
    i.addLazySingleton<ManageLocalUser>(() => ManageLocalUserImpl(i()));
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

    bool isInLocal = await Modular.get<AuthController>().isUserInLocal();

    return isInLocal;
  }
}
