import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/finance_manager/src/utils/umbrella_palette.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/finance_manager/');

    return MaterialApp.router(
      routerConfig: Modular.routerConfig,
      debugShowCheckedModeBanner: false,
      title: 'Umbrella Echonomics',
      theme: ThemeData(
        primaryColor: UmbrellaPalette.primaryColor,
        expansionTileTheme: ExpansionTileThemeData(
          expansionAnimationStyle: AnimationStyle(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 500),
          ),
          shape: const Border(),
          tilePadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
