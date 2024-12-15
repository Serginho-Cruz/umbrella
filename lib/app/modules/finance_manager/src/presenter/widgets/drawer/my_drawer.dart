import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user_state.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/stores/auth_store.dart';
import 'package:umbrella_echonomics/app/modules/bind_service_provider.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/routes.dart';

import 'custom_drawer_header.dart';
import 'drawer_item.dart';
import 'drawer_logout_item.dart';

part 'drawer_routes.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final User _user =
      (BindServiceProvider.get<AuthStore>().state as SuccessState).user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 12.0,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          CustomDrawerHeader(username: _user.name, userEmail: _user.email),
          ..._itensData.map((data) => DrawerItem(
                icon: Icon(data.iconData, color: Colors.black),
                route: data.route,
                title: data.title,
              )),
          const Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: DrawerLogoutItem(),
            ),
          ),
        ],
      ),
    );
  }
}
