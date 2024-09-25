abstract interface class Validate {
  String? name(String? name);
  String? email(String? email);
  String? password(
    String? password, {
    PasswordValidationMode mode = PasswordValidationMode.full,
  });
  String? confirmPassword(String? password, String? confirmPassword);
}

enum PasswordValidationMode { full, granular }
