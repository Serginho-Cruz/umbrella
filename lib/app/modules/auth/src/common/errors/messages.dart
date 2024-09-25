abstract final class Messages {
  static const String _tryAgain = 'Por favor, tente novamente';
  static const String _tryAgainLater = '$_tryAgain mais tarde';

  static const String emailAlreadyRegistered =
      "Esse E-mail já foi cadastrado para outro usuário, por favor insira outro";

  static const String genericAuthFail =
      "Um Problema ocorreu durante o processo de login. $_tryAgain";

  static const String genericUserFail =
      "Um Problema inesperado ocorreu. $_tryAgainLater";

  static const String incorrectCredentials =
      "Usuário ou Senha incorretos. Verifique e tente novamente";

  static const String invalidEmail =
      'E-mail Inválido. Verifique se o email está correto e tente novamente';

  static const String mustloginAgain =
      'Sua seção expirou. É necessário fazer novamete o Log In';

  static const String storeError =
      "Erro ao tentar armazenar o usuário localmente";

  static const String retrieveError =
      "Erro ao tentar recuperar o usuário localmente";

  static const String localUserCorrupted =
      'Os seus dados estão corrompidos, o Log In deverá ser feito novamente.';

  static const String localUserDoesntExist =
      "O Usuário não foi armazenado localmente";

  static const String deleteLocalUserError =
      "Houve um erro ao tentar deletar o usuário local";

  static const String registerUserError =
      "Houve um erro ao tentar cadastrar você no sistema. $_tryAgainLater";

  static const String updateUserError =
      "Houve um erro ao tentar atualizar os dados. $_tryAgainLater";

  static const String deleteUserError =
      "Houve um erro ao tentar deletar o seu usuário. $_tryAgainLater";

  static const String networkError =
      'Não foi possível se conectar à internet. Por favor, resolva o problema e tente novamente';

  static const String forbiddenAction = 'Esta ação não pode ser realizada';

  static const String error404 = 'Erro 404: O servidor não foi encontrado';

  static const String serverError =
      'Houve um Problema em nosso servidor. $_tryAgainLater';

  static const String unauthorizedError =
      'A ação só pode ser realizada por usuários logados';
}
