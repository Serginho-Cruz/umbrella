import '../errors/validation_errors.dart';
import '../regular_expressions/regular_expressions.dart';
import 'base_validator.dart';

final class PasswordGranularValidator extends BaseValidator<String?> {
  @override
  String? validate(String? validation) {
    return switch (validation) {
      String? v when v == null || v.trim().isEmpty =>
        ValidationErrors.requiredField,
      String v when v.length < 8 => ValidationErrors.insufficientLength(8),
      String v when v.length > 20 => ValidationErrors.maxLength(20),
      String v when !RegularExpressions.hasOneLetter.hasMatch(v) =>
        ValidationErrors.mustContainOneLetter,
      String v when !RegularExpressions.hasOneSpecialCharacter.hasMatch(v) =>
        ValidationErrors.mustContainOneSpecialCharacter,
      _ => nextValidator?.validate(validation),
    };
  }
}
