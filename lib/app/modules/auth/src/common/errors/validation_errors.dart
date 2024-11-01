abstract final class ValidationErrors {
  static String get incorrectCredentials => 'Email ou Senha incorretos';

  static String insufficientLength(int minLength) =>
      'Esse campo deve ter pelo menos $minLength caracteres';

  static String maxLength(int maxLength) =>
      'Esse campo só pode ter até $maxLength caracteres';

  static String get onlyLetters => 'Esse campo aceita apenas letras';

  static String get invalidPassword => 'Senha Inválida';

  static String get invalidEmail => 'Email Inválido';

  static String get mustContainOneLetter =>
      'Esse campo deve conter pelo menos 1 letra';

  static String get mustContainOneSpecialCharacter =>
      'Esse campo deve conter pelo menos 1 caractere especial';

  static String get requiredField => 'Esse campo é obrigatório';

  static String get passwordsMustBeEqual => 'As senhas precisam ser iguais';
}
