import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user_state.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/stores/auth_store.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final String _prefix = '/finance_manager';
  final User user = (Modular.get<AuthStore>().state as SuccessState).user;

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
            title: 'Receitas',
            icon: const Icon(Icons.attach_money),
            routeName: '/income',
          ),
          _makeDrawerOption(
            context,
            title: 'Despesas',
            icon: const Icon(Icons.money_off_rounded),
            routeName: '/expense',
          ),
          _makeDrawerOption(
            context,
            title: 'Meus Cartões',
            icon: const Icon(Icons.credit_card),
            routeName: '/card',
          ),
          _makeDrawerOption(
            context,
            icon: const Icon(Icons.bar_chart),
            title: 'Gráficos',
            routeName: '/graphics',
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
