import '../../common/errors/validation_errors.dart';
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
    if (password != confirmPassword || confirmPassword != null) {
      return ValidationErrors.passwordsMustBeEqual;
    }
    return null;
  }

  @override
  String? email(String? email) {
    return ValidationChain<String?>([EmailValidator()]).validate(email);
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
    final ValidationChain<String?> chain;

    chain = switch (mode) {
      PasswordValidationMode.granular => ValidationChain([
          PasswordGranularValidator(),
        ]),
      PasswordValidationMode.full => ValidationChain([
          PasswordValidator(),
        ]),
    };

    return chain.validate(password);
  }
}
