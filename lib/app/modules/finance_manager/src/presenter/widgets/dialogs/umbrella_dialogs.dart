import 'package:flutter/material.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../texts/medium_text.dart';
import '../texts/title_text.dart';
import 'dialog_layout.dart';

sealed class UmbrellaDialogs {
  static void showError(
    BuildContext context,
    String fail, {
    VoidCallback? onRetry,
    VoidCallback? onConfirmPressed,
  }) {
    _show(
      context,
      title: 'Oops! Algo aconteceu',
      titleColor: Colors.red,
      icon: Icons.close_rounded,
      iconColor: Colors.red,
      message: fail,
      onRetry: onRetry,
      onConfirmPressed: onConfirmPressed,
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onConfirmPressed,
  }) {
    _show(
      context,
      title: title,
      titleColor: Colors.green,
      icon: Icons.check_sharp,
      iconColor: Colors.green,
      message: message,
      onConfirmPressed: onConfirmPressed,
    );
  }

  static void showNetworkProblem(
    BuildContext context, {
    VoidCallback? onRetry,
    VoidCallback? onConfirmPressed,
  }) {
    _show(
      context,
      title: 'Sem Conexão',
      titleColor: Colors.black,
      icon: Icons.wifi_off_rounded,
      iconColor: Colors.yellow,
      message:
          'O Umbrella não conseguiu acessar a internet. Verifique a conexão e tente novamente',
      onRetry: onRetry,
      onConfirmPressed: onConfirmPressed,
    );
  }

  static void _show(
    BuildContext context, {
    required String title,
    required Color titleColor,
    required String message,
    required IconData icon,
    required Color iconColor,
    final VoidCallback? onRetry,
    final VoidCallback? onConfirmPressed,
  }) {
    showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return DialogLayout(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  shape: CircleBorder(
                    side: BorderSide(color: iconColor, width: 3.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Icon(icon, color: iconColor, size: 60.0),
                  ),
                ),
                const SizedBox(height: 30.0),
                TitleText.bold(
                  title,
                  color: titleColor,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                MediumText(message, textAlign: TextAlign.center),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: onRetry == null
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    if (onRetry != null)
                      SecondaryButton(
                        label: const MediumText('Tentar Novamente'),
                        onPressed: () {
                          Navigator.pop(context);
                          onRetry();
                        },
                      ),
                    PrimaryButton(
                      label: const MediumText('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirmPressed?.call();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
    );
  }
}
