import '../../common/errors/fail.dart';
import 'user.dart';

sealed class UserState {
  const UserState();
}

final class InitialState extends UserState {
  const InitialState();
}

final class LoadingState extends UserState {
  const LoadingState();
}

final class SuccessState extends UserState {
  final User user;

  const SuccessState(this.user);
}

final class FailState extends UserState {
  final Fail fail;

  const FailState(this.fail);
}
