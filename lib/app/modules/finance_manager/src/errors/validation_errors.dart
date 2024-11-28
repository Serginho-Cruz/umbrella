abstract class ValidationErrors {
  static String insufficientLength(int minLength) =>
      "Esse campo deve ter pelo menos $minLength caracteres";

  static String maxLength(int maxLength) =>
      "Esse campo só pode ter até $maxLength caracteres";

  static const String requiredField = "Esse campo é obrigatório";

  static const String accountIsRequired =
      'Uma conta deve ser selecionada obrigatoriamente';

  static const String categoryIsRequired =
      'Uma categoria deve ser selecionada obrigatoriamente';

  static const String invalidAccount = 'A conta escolhida é inválida';

  static const String invalidCategory = 'A categoria escolhida é inválida';

  static const String dueDateOutOfRange =
      'A data de vencimento deve ser pelo menos em Janeiro de 2024';

  static String minValue(double min) =>
      'O valor desse campo deve ser pelo menos $min';

  static String maxValue(double max) =>
      'O valor desse campo deve ser no máximo $max';
}
