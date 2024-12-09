part of 'my_drawer.dart';

class _DrawerItemData {
  final String title;
  final IconData iconData;
  final String route;

  _DrawerItemData({
    required this.title,
    required this.iconData,
    required this.route,
  });
}

List<_DrawerItemData> get _itensData {
  return [
    _DrawerItemData(
      title: 'Home',
      iconData: Icons.home_rounded,
      route: FinanceRoutes.home,
    ),
    _DrawerItemData(
      title: 'Receitas',
      iconData: Icons.attach_money,
      route: FinanceRoutes.incomes,
    ),
    _DrawerItemData(
      title: 'Despesas',
      iconData: Icons.money_off_rounded,
      route: FinanceRoutes.expenses,
    ),
    _DrawerItemData(
      title: 'Meus Cartões',
      iconData: Icons.credit_card,
      route: FinanceRoutes.cards,
    ),
    _DrawerItemData(
      title: 'Pessoas',
      iconData: Icons.person,
      route: FinanceRoutes.persons,
    ),
    _DrawerItemData(
      title: 'Gráficos',
      iconData: Icons.bar_chart,
      route: FinanceRoutes.charts,
    ),
    _DrawerItemData(
      title: 'Registros',
      iconData: Icons.receipt,
      route: FinanceRoutes.records,
    ),
  ];
}
