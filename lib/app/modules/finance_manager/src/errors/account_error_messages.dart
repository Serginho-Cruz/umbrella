abstract final class AccountMessages {
  static const String oldAccountNotFound =
      'Não foi possível atualizar a antiga conta. Por favor tente novamente mais tarde';

  static const String accountNotFoundForDelete =
      'Não foi possível encontrar a conta. Por favor tente novamente mais tarde';

  static String userHasntAccounts(String username) =>
      "Não há contas registradas para o usuário $username";
}
