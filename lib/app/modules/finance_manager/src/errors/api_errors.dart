import 'errors.dart';

class InternalServerError extends Fail {
  InternalServerError()
      : super(
            'Houve um problema no servidor. Por favor, tente novamente mais tarde');
}

class Error404 extends Fail {
  Error404()
      : super(
            'Houve um problema no servidor. Por favor, tente novamente mais tarde');
}

class UnauthorizedFail extends Fail {
  UnauthorizedFail()
      : super('Você precisa estar logado para realizar esta ação');
}

class ForbiddenAction extends Fail {
  ForbiddenAction()
      : super('Você não possui permissão para realizar esta ação');
}
