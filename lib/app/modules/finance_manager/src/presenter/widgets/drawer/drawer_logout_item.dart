// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/stores/auth_store.dart';
import 'package:umbrella_echonomics/app/modules/bind_service_provider.dart';

class DrawerLogoutItem extends StatelessWidget {
  const DrawerLogoutItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Logout'),
      leading: const Icon(Icons.logout, color: Colors.black),
      style: ListTileStyle.drawer,
      onTap: () async {
        Navigator.popUntil(context, (r) => r.isFirst);
        Navigator.pushReplacementNamed(context, '/auth');
        BindServiceProvider.get<AuthStore>().logout();
      },
    );
  }
}
