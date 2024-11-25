import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart' show ModularApp;
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart'
    show Parse;
import 'package:umbrella_echonomics/env.dart';

import 'app/app_module.dart';
import 'app/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Parse()
      .initialize(Env.appId, Env.url, clientKey: Env.clientKey, debug: false);

  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}
