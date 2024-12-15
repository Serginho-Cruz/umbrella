import '../../../common/validators/max_length_validator.dart';
import '../../../common/validators/min_length_validator.dart';
import '../../../common/validators/required_validator.dart';
import '../../../common/validators/validation_chain.dart';
import '../../../domain/usecases/validates/validate_account.dart';
import '../../../errors/validation_errors.dart';

class ValidateAccountImpl implements ValidateAccount {
  @override
  String? validateBalance(double balance) {
    if (balance < 0.00) return ValidationErrors.minValue(0.00);
    if (balance > 1000000000) return ValidationErrors.maxValue(1000000000);

    return null;
  }

  @override
  String? validateName(String? name) {
    return ValidationChain<String?>([
      RequiredValidator(),
      MinLengthValidator(minLength: 3),
      MaxLengthValidator(maxLength: 20),
    ]).validate(name);
  }
}
