import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';

import '../../entities/category.dart';
import '../../entities/date.dart';

abstract class ValidateExpense {
  String? validateAccount(Account? account);
  String? validateName(String? name);
  String? validateValue(double value);
  String? validateDueDate(Date dueDate);
  String? validatePersonName(String? personName);
  String? validateCategory(Category? category);
  String? validateAll({
    required Account? account,
    required String? name,
    required double value,
    required Date dueDate,
    required String? personName,
    required Category? category,
  });
}
