import 'package:flutter/material.dart';

abstract final class LoadingDialog {
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          side: const BorderSide(),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const UnconstrainedBox(
          child: SizedBox.square(
            dimension: 200,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
