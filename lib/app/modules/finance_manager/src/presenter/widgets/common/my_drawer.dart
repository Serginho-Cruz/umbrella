import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 12.0,
      child: ListView(
        children: [
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home_rounded, color: Colors.white),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/finance_manager/');
            },
          ),
          ListTile(
            title: const Text('Adicionar Despesa'),
            leading: const Icon(Icons.add_circle_outline, color: Colors.red),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed('/finance_manager/expense/add');
            },
          ),
          ListTile(
            title: const Text('Adicionar Receita'),
            leading:
                const Icon(Icons.add_circle_outline, color: Colors.lightGreen),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed('/finance_manager/income/add');
            },
          )
        ],
      ),
    );
  }
}
