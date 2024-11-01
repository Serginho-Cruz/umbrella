import '../../errors/errors.dart';

sealed class GraphsState<T extends Map> {}

class GraphsLoadingState<T extends Map> extends GraphsState<T> {}

class GraphsSuccessState<T extends Map> extends GraphsState<T> {
  T data;

  GraphsSuccessState(this.data);
}

class GraphsErrorState<T extends Map> extends GraphsState<T> {
  Fail fail;

  GraphsErrorState(this.fail);
}
