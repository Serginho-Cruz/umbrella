import 'package:flutter/material.dart';

import '../../../domain/entities/date.dart';
import '../appbar/custom_app_bar.dart';
import '../my_drawer.dart';

class UmbrellaScaffold extends StatelessWidget {
  const UmbrellaScaffold({
    super.key,
    required this.body,
    this.onMonthChange,
    this.appBarTitle,
    this.monthAndYear,
    this.showBalances = true,
    this.showMonthChanger = false,
    this.floatingActionButton,
  });

  final Widget body;

  ///AppBar's onMonthChange method
  final void Function(int, int)? onMonthChange;

  final String? appBarTitle;

  ///See [CustomAppBar] class to understand more
  final Date? monthAndYear;

  final bool showBalances;
  final bool showMonthChanger;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: appBarTitle,
          showBalances: showBalances,
          showMonthChanger: showMonthChanger,
          onMonthChange: onMonthChange,
          monthAndYear: monthAndYear,
        ),
        drawer: MyDrawer(),
        backgroundColor: Colors.white,
        body: body,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
