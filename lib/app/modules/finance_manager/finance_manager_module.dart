import 'package:flutter_modular/flutter_modular.dart';

import '../auth/auth_module.dart';

import 'bindings/controllers_bindings.dart';
import 'bindings/datasources_bindings.dart';
import 'bindings/repositories_bindings.dart';
import 'bindings/usecases_bindings.dart';
import 'register_routes.dart';

class FinanceManagerModule extends Module {
  @override
  List<Module> get imports => [AuthModule()];

  @override
  void binds(Injector i) {
    DatasourcesBindings.bind(i);
    RepositoriesBindings.bind(i);
    UsecasesBindings.bind(i);
    ControllersBindings.bind(i);
  }

  @override
  void routes(RouteManager r) {
    RegisterRoutes.register(r);
  }
}
