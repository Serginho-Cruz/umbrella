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
    Key? key,
  }) {
    return NavigationButton(
      context: context,
      isPrimaryColor: false,
      route: '/finance_manager/expense',
      label: const MediumText.bold('Ver Despesas'),
      icon: const Icon(Icons.money_off_rounded, color: Colors.black),
    );
  }

  factory NavigationButton.toIncomes(
    BuildContext context, {
    Key? key,
  }) {
    return NavigationButton(
      context: context,
      isPrimaryColor: false,
      route: '/finance_manager/income',
      label: const MediumText.bold('Ver Receitas'),
      icon: const Icon(Icons.attach_money, color: Colors.black),
    );
  }

  factory NavigationButton.toCards(
    BuildContext context, {
    Key? key,
  }) {
    return NavigationButton(
      context: context,
      isPrimaryColor: false,
      route: '/finance_manager/card',
      label: const MediumText.bold('Ver Cartões'),
      icon: const Icon(Icons.credit_card, color: Colors.black),
    );
  }
}
