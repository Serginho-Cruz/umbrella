import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/validates/validate_credit_card.dart';

import '../../../common/validators/max_length_validator.dart';
import '../../../common/validators/min_length_validator.dart';
import '../../../common/validators/required_validator.dart';
import '../../../common/validators/validation_chain.dart';

class ValidateCreditCardImpl implements ValidateCreditCard {
  @override
  String? validateAccount(Account? account) {
    return ValidationChain<Account?>([RequiredValidator()]).validate(account);
  }

  @override
  String? validateName(String? name) {
    return ValidationChain<String?>([
      RequiredValidator(),
      MinLengthValidator(minLength: 4),
      MaxLengthValidator(maxLength: 20),
    ]).validate(name);
  }
}
