import '../../entities/account.dart';

abstract interface class ValidateCreditCard {
  String? validateName(String? name);
  String? validateAccount(Account? account);
}
