import '../errors/validation_errors.dart';
import '../regular_expressions/regular_expressions.dart';
import 'base_validator.dart';

final class PasswordValidator extends BaseValidator<String?> {
  @override
  String? validate(String? validation) {
    if (validation == null) return ValidationErrors.invalidPassword;

    bool hasLength, hasLetter, hasSpecialCharacter;

    hasLength = validation.length >= 8 && validation.length <= 20;

    hasLetter = validation.contains(RegularExpressions.hasOneLetter);

    hasSpecialCharacter =
        RegularExpressions.hasOneSpecialCharacter.hasMatch(validation);

    if (hasLength && hasLetter && hasSpecialCharacter) {
      return nextValidator?.validate(validation);
    }

    return ValidationErrors.invalidPassword;
  }
}
