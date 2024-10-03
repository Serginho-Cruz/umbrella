import '../errors/validation_errors.dart';
import 'base_validator.dart';

final class RequiredValidator extends BaseValidator<String?> {
  @override
  String? validate(String? validation) {
    return validation == null || validation.isEmpty
        ? ValidationErrors.requiredField
        : nextValidator?.validate(validation);
  }
}
