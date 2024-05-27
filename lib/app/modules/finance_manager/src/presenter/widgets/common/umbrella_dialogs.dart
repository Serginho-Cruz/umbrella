import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/umbrella_palette.dart';

sealed class UmbrellaDialogs {
  static void showError(
    BuildContext context,
    Fail fail, {
    VoidCallback? onRetry,
    VoidCallback? onConfirmPressed,
  }) {
    _show(
      context,
      title: 'Oops! Algo aconteceu',
      titleColor: Colors.red,
      icon: Icons.close_rounded,
      iconColor: Colors.red,
      message: fail.message,
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
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation,
          child: Dialog(
            elevation: 8.0,
            backgroundColor: Colors.white,
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
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 60.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: onRetry == null
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      if (onRetry != null)
                        FilledButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.any((state) =>
                                  state == MaterialState.hovered ||
                                  state == MaterialState.pressed)) {
                                return UmbrellaPalette.activeSecondaryButton;
                              }

                              return UmbrellaPalette.secondaryButtonColor;
                            }),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0))),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            onRetry();
                          },
                          child: const Text(
                            'Tentar Novamente',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      FilledButton(
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0))),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirmPressed?.call();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
