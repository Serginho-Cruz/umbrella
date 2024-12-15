import 'package:flutter/material.dart';
import '../../../domain/states/state.dart' as s;
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

  final s.State<T> state;
  final Widget Function(BuildContext, T) onState;
  final Widget Function(BuildContext, Fail) onFail;
  final Widget Function(BuildContext) onLoading;

  /// If not specified, a [SizedBox.shrink()] is used as default
  final Widget Function(BuildContext)? onInitial;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      s.LoadingState<T>() => onLoading(context),
      s.FailState<T>(fail: var fail) => onFail(context, fail),
      s.SuccessState<T>(state: var state) => onState(context, state),
      s.InitialState<T>() =>
        onInitial?.call(context) ?? const SizedBox.shrink(),
      s.State<T>() => const SizedBox.shrink(),
    };
  }
}
