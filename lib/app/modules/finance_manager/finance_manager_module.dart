import 'package:flutter_modular/flutter_modular.dart';

import 'src/presenter/screens/home_screen.dart';

class FinanceManagerModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.add(ChildRoute('/', child: (context) => HomeScreen()));
  }
}
