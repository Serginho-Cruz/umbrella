import 'package:flutter_modular/flutter_modular.dart';
import 'modules/auth/auth_module.dart';
import 'modules/core/core_module.dart';
import 'modules/finance_manager/finance_manager_module.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [AuthModule(), CoreModule()];

  @override
  void routes(RouteManager r) {
    r.module('/', module: FinanceManagerModule(), guards: [AuthGuard()]);
    r.module('/auth', module: AuthModule());
  }
}
