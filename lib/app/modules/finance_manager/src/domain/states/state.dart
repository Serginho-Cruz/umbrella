import '../../errors/errors.dart';

abstract class State<T extends Object> {
  const State();
}

class InitialState<T extends Object> extends State<T> {
  const InitialState();
}

class LoadingState<T extends Object> extends State<T> {
  const LoadingState();
}

class SuccessState<T extends Object> extends State<T> {
  final T state;

  const SuccessState(this.state);
}

class FailState<T extends Object> extends State<T> {
  final Fail fail;

  const FailState(this.fail);
}
