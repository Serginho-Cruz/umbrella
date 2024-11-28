import '../../errors/validation_errors.dart';
import 'base_validator.dart';

final class MaxLengthValidator extends BaseValidator<String?> {
  final int maxLength;

  MaxLengthValidator({required this.maxLength});

  @override
  String? validate(String? validation) {
    if (validation == null || validation.length > maxLength) {
      return ValidationErrors.maxLength(maxLength);
    }
    return nextValidator?.validate(validation);
  }
}
