import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blue,
      elevation: 12.0,
      child: ListView(
        children: [
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home_rounded, color: Colors.white),
            onTap: () {
              Modular.to.pushReplacementNamed('/');
            },
          ),
          ListTile(
            title: const Text('Adicionar Despesa'),
            leading: const Icon(Icons.add_circle_outline, color: Colors.red),
            onTap: () {
              Modular.to.pushReplacementNamed('/expense/add');
            },
          )
        ],
      ),
    );
  }
}
