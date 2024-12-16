import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/animations/creating_data_animation.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/animations/erasing_data_animation.dart';

import '../../../domain/states/state.dart' as s;
import '../../utils/loading_animation_type.dart';
import '../animations/loading_animation.dart';

class LoadingAnimationCrossfade extends StatelessWidget {
  const LoadingAnimationCrossfade({
    super.key,
    required this.state,
    required this.animationWidth,
    required this.animationHeight,
    required this.animationText,
    required this.child,
    this.type = LoadingAnimationType.defaultLoading,
  });

  final s.State state;
  final double animationWidth;
  final double animationHeight;
  final String animationText;
  final LoadingAnimationType type;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.center,
      firstCurve: Curves.decelerate,
      secondCurve: Curves.decelerate,
      layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
        return Stack(
          alignment: Alignment.center,
          children: [topChild],
        );
      },
      crossFadeState: state is s.LoadingState
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: _resolveType(
        width: animationWidth,
        height: animationHeight,
        message: animationText,
      ),
      secondChild: child,
    );
  }

  Widget Function({
    required double width,
    required double height,
    required String message,
  }) get _resolveType {
    return switch (type) {
      LoadingAnimationType.create => CreatingDataAnimation.new,
      LoadingAnimationType.defaultLoading => LoadingAnimation.new,
      LoadingAnimationType.erase => ErasingDataAnimation.new,
    };
  }
}
