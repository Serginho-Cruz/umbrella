import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/category.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/validates/validate_income.dart';

import '../../../common/validators/max_length_validator.dart';
import '../../../common/validators/min_length_validator.dart';
import '../../../common/validators/required_validator.dart';
import '../../../common/validators/validation_chain.dart';
import '../../../errors/validation_errors.dart';

class ValidateIncomeImpl implements ValidateIncome {
  @override
  String? validateAccount(Account? account) {
    if (account == null) return ValidationErrors.accountIsRequired;

    return account.id.isEmpty ? ValidationErrors.invalidAccount : null;
  }

  @override
  String? validateCategory(Category? category) {
    if (category == null) return ValidationErrors.categoryIsRequired;

    return category.id.isEmpty ? ValidationErrors.invalidCategory : null;
  }

  @override
  String? validateDueDate(Date dueDate) {
    Date lastOfDecember2023 = Date(day: 31, month: 12, year: 2023);

    if (dueDate.isAfter(lastOfDecember2023)) return null;

    return ValidationErrors.dueDateOutOfRange;
  }

  @override
  String? validateName(String? name) {
    return ValidationChain<String?>([
      RequiredValidator(),
      MinLengthValidator(minLength: 5),
      MaxLengthValidator(maxLength: 25),
    ]).validate(name);
  }

  @override
  String? validatePersonName(String? personName) {
    if (personName == null) return null;

    return ValidationChain<String?>([
      MinLengthValidator(minLength: 3),
      MaxLengthValidator(maxLength: 15),
    ]).validate(personName);
  }

  @override
  String? validateValue(double value) {
    if (value <= 0.00) return ValidationErrors.minValue(0.00);
    if (value >= 1000000000) return ValidationErrors.maxValue(1000000000 - 1);

    return null;
  }

  @override
  String? validateAll({
    required Account? account,
    required String? name,
    required double value,
    required Date dueDate,
    required String? personName,
    required Category? category,
  }) {
    String? error;

    error = validateAccount(account);
    if (error != null) return error;

    error = validateName(name);
    if (error != null) return error;

    error = validateValue(value);
    if (error != null) return error;

    error = validateDueDate(dueDate);
    if (error != null) return error;

    error = validatePersonName(personName);
    if (error != null) return error;

    return validateCategory(category);
  }
}
