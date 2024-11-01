sealed class RegularExpressions {
  static final hasOneSpecialCharacter = RegExp(r'[!@#$%^&*()_,.?":{}|<>]');
  static final hasOneLetter = RegExp('[a-zA-Z]');
  static final hasNonLetterCharacter =
      RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
}
