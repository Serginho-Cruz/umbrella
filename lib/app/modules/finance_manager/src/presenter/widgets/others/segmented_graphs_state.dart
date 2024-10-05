import 'package:flutter/material.dart';

import '../../../domain/states/graphs_state.dart';

class SegmentedGraphsState<T extends Map> extends StatelessWidget {
  const SegmentedGraphsState({
    super.key,
    required this.observable,
    required this.onSuccess,
    required this.onFail,
    required this.onLoading,
  });

  final GraphsState<T> observable;
  final Widget Function(BuildContext context, GraphsSuccessState<T>) onSuccess;
  final Widget Function(BuildContext context, GraphsErrorState<T>) onFail;
  final Widget Function(BuildContext context) onLoading;

  @override
  Widget build(BuildContext context) {
    return switch (observable) {
      GraphsSuccessState<T> success => onSuccess(context, success),
      GraphsErrorState<T> fail => onFail(context, fail),
      GraphsLoadingState<T>() => onLoading(context),
    };
  }
}
