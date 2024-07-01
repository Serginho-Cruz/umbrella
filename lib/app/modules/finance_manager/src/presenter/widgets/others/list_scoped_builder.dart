import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../errors/errors.dart';

class ListScopedBuilder<St extends Store<S>, S extends List<Object>>
    extends StatelessWidget {
  const ListScopedBuilder({
    super.key,
    required this.store,
    required this.loadingWidget,
    required this.onState,
    required this.onError,
    required this.onEmptyState,
  });

  final St store;
  final Widget loadingWidget;
  final Widget Function(BuildContext context, S state) onState;
  final Widget Function(BuildContext context, Fail fail) onError;
  final Widget Function() onEmptyState;

  @override
  Widget build(BuildContext context) {
    return ScopedBuilder<St, S>(
      store: store,
      onState: (context, state) {
        return state.isEmpty ? onEmptyState() : onState(context, state);
      },
      onError: (context, error) {
        Fail fail = error as Fail;
        return onError(context, fail);
      },
      onLoading: (context) => loadingWidget,
    );
  }
}
