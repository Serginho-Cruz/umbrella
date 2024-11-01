import '../errors/validation_errors.dart';
import '../regular_expressions/regular_expressions.dart';
import 'base_validator.dart';

final class OnlyLettersValidator extends BaseValidator<String?> {
  @override
  String? validate(String? validation) {
    if (validation == null ||
        RegularExpressions.hasNonLetterCharacter.hasMatch(validation)) {
      return ValidationErrors.onlyLetters;
    }

    return nextValidator?.validate(validation);
  }
}
