abstract class ValidationErrors {
  static String insufficientLength(int minLength) =>
      "Esse campo deve ter pelo menos $minLength caracteres";

  static String maxLength(int maxLength) =>
      "Esse campo só pode ter até $maxLength caracteres";

  static const String requiredField = "Esse campo é obrigatório";
}
