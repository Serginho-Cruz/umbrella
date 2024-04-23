import 'package:flutter_modular/flutter_modular.dart';

import 'src/mysql_connection_provider.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addSingleton(() => MysqlConnectionProvider.instance);
    super.exportedBinds(i);
  }
}
