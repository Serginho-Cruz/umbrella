import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart'
    show ParseResponse, ParseError;

import '../../errors/api_errors.dart';
import '../../errors/errors.dart';

bool isResponseSuccesful(ParseResponse response) {
  return response.success & [200, 201].contains(response.statusCode);
}

Fail extractFail(
  ParseResponse response, {
  Map<int, Fail>? returnOn,
}) {
  returnOn = returnOn ?? const {};
  int? errorCode = response.error?.code;

  switch (errorCode) {
    case ParseError.connectionFailed:
      return const NetworkFail();

    case ParseError.operationForbidden:
      return const ForbiddenAction();

    case ParseError.internalServerError:
      return const InternalServerError();
  }

  if (returnOn.containsKey(errorCode)) return returnOn[errorCode]!;

  return switch (response.statusCode) {
    401 => const UnauthorizedFail(),
    404 => const Error404(),
    500 => const InternalServerError(),
    _ => const GenericError(),
  };
}
