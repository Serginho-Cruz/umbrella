import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/controllers/auth_controller.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final String _prefix = '/finance_manager';
  final User user = Modular.get<AuthController>().user!;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 12.0,
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          //TODO: Make the Header of Drawer with User's name, email and first letter
          _makeDrawerOption(
            context,
            title: 'Home',
            icon: const Icon(Icons.home_rounded, color: Colors.black),
            routeName: '/',
          ),
          _makeDrawerOption(
            context,
            title: 'Adiicionar Despesa',
            icon: const Icon(Icons.add_circle_outline, color: Colors.red),
            routeName: '/expense/add',
          ),
          _makeDrawerOption(
            context,
            title: 'Adicionar Receita',
            icon:
                const Icon(Icons.add_circle_outline, color: Colors.lightGreen),
            routeName: '/income/add',
          ),
          _makeDrawerOption(
            context,
            title: 'Adicionar Cartão',
            icon: const Icon(Icons.add_circle_outline, color: Colors.lightBlue),
            routeName: '/card/add',
          ),
        ],
      ),
    );
  }

  ///Makes a Drawer Option that navigates to other screens. Don't use the prefix on [routeName]
  Widget _makeDrawerOption(
    BuildContext context, {
    required String title,
    required Icon icon,
    required String routeName,
  }) {
    return ListTile(
      title: Text(title),
      leading: icon,
      style: ListTileStyle.drawer,
      onTap: () {
        Navigator.of(context).pushReplacementNamed('$_prefix$routeName');
      },
    );
  }
}
