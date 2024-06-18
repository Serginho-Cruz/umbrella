import 'package:flutter/material.dart';

import '../../../utils/umbrella_palette.dart';
import '../texts/medium_text.dart';
import 'umbrella_button.dart';

class NavigationButton extends UmbrellaButton {
  NavigationButton({
    super.key,
    required BuildContext context,
    required String route,
    required super.label,
    super.width,
    super.height,
    bool isPrimaryColor = true,
    super.icon,
  }) : super(
          backgroundColor: isPrimaryColor
              ? UmbrellaPalette.actionButtonColor
              : UmbrellaPalette.secondaryButtonColor,
          hoverColor: isPrimaryColor
              ? UmbrellaPalette.activePrimaryButton
              : UmbrellaPalette.activeSecondaryButton,
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
        );

  factory NavigationButton.toExpenses(
    BuildContext context, {
    bool isPrimaryColor = false,
    Widget label = const MediumText.bold('Ver Despesas'),
    Icon icon = const Icon(Icons.money_off_rounded, color: Colors.black),
    double? height,
    double? width,
    Key? key,
  }) {
    return NavigationButton(
      key: key,
      context: context,
      route: '/finance_manager/expense',
      isPrimaryColor: isPrimaryColor,
      label: label,
      icon: icon,
      height: height,
      width: width,
    );
  }

  factory NavigationButton.toIncomes(
    BuildContext context, {
    Key? key,
    bool isPrimaryColor = false,
    Widget label = const MediumText.bold('Ver Receitas'),
    Icon icon = const Icon(Icons.attach_money, color: Colors.black),
    double? height,
    double? width,
  }) {
    return NavigationButton(
      key: key,
      context: context,
      isPrimaryColor: isPrimaryColor,
      route: '/finance_manager/income',
      label: label,
      icon: icon,
      height: height,
      width: width,
    );
  }

  factory NavigationButton.toCards(
    BuildContext context, {
    Key? key,
    bool isPrimaryColor = false,
    Widget label = const MediumText.bold('Ver Cartões'),
    Icon icon = const Icon(Icons.credit_card, color: Colors.black),
    double? height,
    double? width,
  }) {
    return NavigationButton(
      key: key,
      context: context,
      route: '/finance_manager/card',
      isPrimaryColor: isPrimaryColor,
      label: label,
      icon: icon,
      height: height,
      width: width,
    );
  }
}
