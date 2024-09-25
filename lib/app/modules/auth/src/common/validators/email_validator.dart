import '../errors/messages.dart';
import 'base_validator.dart';
import 'package:email_validator/email_validator.dart' as email;

final class EmailValidator extends BaseValidator<String?> {
  @override
  String? validate(String? validation) {
    if (validation == null || !email.EmailValidator.validate(validation)) {
      return Messages.invalidEmail;
    }

    return nextValidator?.validate(validation);
  }
}
