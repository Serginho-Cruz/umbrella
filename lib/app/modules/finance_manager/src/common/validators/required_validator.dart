import '../../errors/validation_errors.dart';
import 'base_validator.dart';

final class RequiredValidator<T extends Object?> extends BaseValidator<T> {
  @override
  String? validate(T validation) {
    if (validation == null) return ValidationErrors.requiredField;

    if ((T is String || T is String?)) {
      var val = validation as String;

      if (val.isEmpty) return ValidationErrors.requiredField;
    }
    return nextValidator?.validate(validation);
  }
}
