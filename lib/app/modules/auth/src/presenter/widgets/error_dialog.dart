import 'package:flutter/material.dart';

sealed class ErrorDialog {
  static void show(
    BuildContext context, {
    required String error,
  }) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          elevation: 8.0,
          title: const Text(
            "Oops! Algo deu errado",
            style: TextStyle(
              color: Colors.red,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '$error.',
            style: const TextStyle(
              fontSize: 18.0,
            ),
            textAlign: TextAlign.justify,
          ),
          actions: [
            FilledButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0))),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
