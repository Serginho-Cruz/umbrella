import 'package:flutter/material.dart';

sealed class SuccessDialog {
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String successMessage,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          elevation: 8.0,
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.lightGreen,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            successMessage,
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
