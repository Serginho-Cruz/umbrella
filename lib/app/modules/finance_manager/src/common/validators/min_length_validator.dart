import '../../errors/validation_errors.dart';
import 'base_validator.dart';

final class MinLengthValidator extends BaseValidator<String?> {
  final int minLength;

  MinLengthValidator({required this.minLength});

  @override
  String? validate(String? validation) {
    if (validation == null || validation.length < minLength) {
      return ValidationErrors.insufficientLength(minLength);
    }
    return nextValidator?.validate(validation);
  }
}
