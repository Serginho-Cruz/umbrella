import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/animations/creating_data_animation.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/animations/erasing_data_animation.dart';

import '../../utils/loading_animation_type.dart';
import '../animations/loading_animation.dart';
import '../layout/dialog_layout.dart';

abstract class LoadingDialog {
  static Future<void> show(
    BuildContext context, {
    required String message,
    LoadingAnimationType type = LoadingAnimationType.defaultLoading,
  }) {
    const height = 400.00;
    final width = MediaQuery.sizeOf(context).width * 0.7;
    return showDialog(
      context: context,
      builder: (ctx) => DialogLayout(
        child: switch (type) {
          LoadingAnimationType.create => CreatingDataAnimation(
              width: width,
              height: height,
              message: message,
            ),
          LoadingAnimationType.defaultLoading => LoadingAnimation(
              width: width,
              height: height,
              message: message,
            ),
          LoadingAnimationType.erase => ErasingDataAnimation(
              width: width,
              height: height,
              message: message,
            ),
        },
      ),
    );
  }
}
