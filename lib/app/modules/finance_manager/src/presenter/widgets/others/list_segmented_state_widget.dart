import 'package:flutter/material.dart';
import '../../../domain/states/state.dart' as S;
import '../../../errors/errors.dart';
import 'segmented_state_widget.dart';

class ListSegmentedStateWidget<T extends Object> extends StatelessWidget {
  const ListSegmentedStateWidget({
    super.key,
    required this.state,
    required this.onLoading,
    required this.onFail,
    required this.onState,
    this.onEmpty,
  });

  final S.State<List<T>> state;
  final Widget Function(BuildContext, List<T>) onState;
  final Widget Function(BuildContext, Fail) onFail;
  final Widget Function(BuildContext) onLoading;

  /// If not specified, a [SizedBox.shrink()] is used as default
  final Widget Function(BuildContext)? onEmpty;

  @override
  Widget build(BuildContext context) {
    return SegmentedStateWidget<List<T>>(
      onLoading: onLoading,
      onFail: onFail,
      onState: (ctx, st) =>
          st.isEmpty && onEmpty != null ? onEmpty!(ctx) : onState(ctx, st),
      state: state,
    );
  }
}
