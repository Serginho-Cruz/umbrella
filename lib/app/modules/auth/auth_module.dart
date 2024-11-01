import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

import 'src/data/repositories/user_repository.dart';
import 'src/data/usecases/auth.dart';
import 'src/data/usecases/manage_local_token.dart';
import 'src/data/usecases/manage_user.dart';
import 'src/data/usecases/validate.dart';
import 'src/domain/entities/user_state.dart';
import 'src/domain/usecases/auth.dart';
import 'src/domain/usecases/manage_local_token.dart';
import 'src/domain/usecases/manage_user.dart';
import 'src/domain/usecases/validate.dart';
import 'src/external/datasources/back4app/user_datasource.dart';
import 'src/external/services/token_storage.dart';
import 'src/infra/datasources/user_datasource.dart';
import 'src/infra/repositories/user_repository.dart';
import 'src/infra/services/local_storage_service.dart';
import 'src/presenter/screens/login_screen.dart';
import 'src/presenter/screens/register_screen.dart';
import 'src/presenter/stores/auth_store.dart';

class AuthModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addSingleton(
      () => AuthStore(
        auth: i(),
        manageLocalToken: i(),
        manageUser: i(),
        validateFields: i(),
      ),
    );
    super.exportedBinds(i);
  }

  @override
  void binds(Injector i) {
    super.binds(i);
    i.addLazySingleton<LocalStorageService>(TokenStorage.new);
    i.addLazySingleton<UserDatasource>(Back4AppUserDatasource.new);
    i.addLazySingleton<UserRepository>(
      () => UserRepositoryImpl(i()),
    );
    i.addLazySingleton<ManageLocalToken>(() => ManageLocalTokenImpl(i()));
    i.addLazySingleton<ManageUser>(() => ManageUserImpl(i()));
    i.addLazySingleton<Auth>(
        () => AuthImpl(manageLocalToken: i(), repository: i()));
    i.addLazySingleton<Validate>(ValidateImpl.new);
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);
    r.child(
      '/',
      child: (context) => LoginScreen(
        store: Modular.get<AuthStore>(),
      ),
    );
    r.child(
      '/register',
      child: (context) => RegisterScreen(
        store: Modular.get<AuthStore>(),
      ),
    );
  }
}

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/auth/');

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    var store = Modular.get<AuthStore>();

    if (store.state is SuccessState) return true;

    bool isInLocal = await store.isUserInLocal();

    return isInLocal;
  }
}
