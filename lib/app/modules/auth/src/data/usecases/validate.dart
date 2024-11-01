import '../../common/errors/validation_errors.dart';
import '../../common/validators/base_validator.dart';
import '../../common/validators/email_validator.dart';
import '../../common/validators/max_length_validator.dart';
import '../../common/validators/min_length_validator.dart';
import '../../common/validators/only_letters_validator.dart';
import '../../common/validators/password_granular_validator.dart';
import '../../common/validators/password_validator.dart';
import '../../common/validators/required_validator.dart';
import '../../common/validators/validation_chain.dart';
import '../../domain/usecases/validate.dart';

class ValidateImpl implements Validate {
  @override
  String? confirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return ValidationErrors.requiredField;
    }

    if (password != confirmPassword) {
      return ValidationErrors.passwordsMustBeEqual;
    }
    return null;
  }

  @override
  String? email(String? email) {
    return ValidationChain<String?>([RequiredValidator(), EmailValidator()])
        .validate(email);
  }

  @override
  String? name(String? name) {
    return ValidationChain<String?>([
      RequiredValidator(),
      OnlyLettersValidator(),
      MinLengthValidator(minLength: 10),
      MaxLengthValidator(maxLength: 30),
    ]).validate(name);
  }

  @override
  String? password(
    String? password, {
    PasswordValidationMode mode = PasswordValidationMode.full,
  }) {
    final List<BaseValidator<String?>> validators;

    validators = switch (mode) {
      PasswordValidationMode.granular => [PasswordGranularValidator()],
      PasswordValidationMode.full => [PasswordValidator()],
    };

    validators.insert(0, RequiredValidator());

    return ValidationChain(validators).validate(password);
  }
}
