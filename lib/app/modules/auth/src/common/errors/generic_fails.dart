import 'fail.dart';
import 'messages.dart';

sealed class GenericFail extends Fail {
  const GenericFail(super.message);
}

final class NetworkFail extends GenericFail {
  const NetworkFail() : super(Messages.networkError);
}

final class ForbiddenAction extends GenericFail {
  const ForbiddenAction() : super(Messages.forbiddenAction);
}

final class Error404 extends GenericFail {
  const Error404() : super(Messages.error404);
}

final class InternalServerError extends GenericFail {
  const InternalServerError() : super(Messages.serverError);
}

final class UnauthorizedFail extends GenericFail {
  const UnauthorizedFail() : super(Messages.unauthorizedError);
}
