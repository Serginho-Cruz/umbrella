import 'package:flutter/material.dart';
import '../../../domain/states/state.dart' as S;
import '../../../errors/errors.dart';

class SegmentedStateWidget<T extends Object> extends StatelessWidget {
  const SegmentedStateWidget({
    super.key,
    required this.state,
    required this.onLoading,
    required this.onFail,
    required this.onState,
    this.onInitial,
  });

  final S.State<T> state;
  final Widget Function(BuildContext, T) onState;
  final Widget Function(BuildContext, Fail) onFail;
  final Widget Function(BuildContext) onLoading;

  /// If not specified, a [SizedBox.shrink()] is used as default
  final Widget Function(BuildContext)? onInitial;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      S.LoadingState<T>() => onLoading(context),
      S.FailState<T>(fail: var fail) => onFail(context, fail),
      S.SuccessState<T>(state: var state) => onState(context, state),
      S.InitialState<T>() =>
        onInitial?.call(context) ?? const SizedBox.shrink(),
      S.State<T>() => const SizedBox.shrink(),
    };
  }
}
