import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../errors/api_errors.dart';
import '../../errors/errors.dart';

bool isResponseSuccesful(ParseResponse response) {
  return response.success && [200, 201].contains(response.statusCode);
}

Fail extractFail(ParseResponse response) {
  debugPrint(
      'Status Code: ${response.statusCode}, Erro: ${response.error?.message}');

  switch (response.error?.code) {
    case ParseError.connectionFailed:
      return NetworkFail();

    case ParseError.operationForbidden:
      return ForbiddenAction();
  }

  debugPrint(
      'Status Code: ${response.statusCode}, Erro: ${response.error?.message}');

  return switch (response.statusCode) {
    401 => UnauthorizedFail(),
    404 => Error404(),
    500 => InternalServerError(),
    _ => GenericError(),
  };
}
