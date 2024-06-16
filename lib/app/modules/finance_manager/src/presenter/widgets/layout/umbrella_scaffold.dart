import 'package:flutter/material.dart';

import '../../../domain/entities/date.dart';
import '../appbar/custom_app_bar.dart';
import '../my_drawer.dart';

class UmbrellaScaffold extends StatelessWidget {
  const UmbrellaScaffold({
    super.key,
    this.onMonthChange,
    this.appBarTitle,
    this.monthAndYear,
    this.showBalances = true,
    this.showMonthChanger = false,
    this.floatingActionButton,
    required this.child,
  });

  final Widget child;

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
        drawer: MyDrawer(),
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: appBarTitle,
          showBalances: showBalances,
          showMonthChanger: showMonthChanger,
          onMonthChange: onMonthChange,
          monthAndYear: monthAndYear,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: child,
        ),
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
