import 'backend_error_messages.dart';
import 'errors.dart';

class InternalServerError extends Fail {
  const InternalServerError() : super(BackendErrorMessages.internalError);
}

class Error404 extends Fail {
  const Error404() : super(BackendErrorMessages.error404);
}

class UnauthorizedFail extends Fail {
  const UnauthorizedFail() : super(BackendErrorMessages.unauthorized);
}

class ForbiddenAction extends Fail {
  const ForbiddenAction() : super(BackendErrorMessages.forbiddenAction);
}

class NetworkFail extends Fail {
  const NetworkFail() : super(BackendErrorMessages.networkFailure);
}
