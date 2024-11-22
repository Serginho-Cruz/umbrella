abstract base class BaseValidator<T extends Object?> {
  BaseValidator<T>? _nextValidator;
  void setNextValidator(BaseValidator<T> validator) =>
      _nextValidator = validator;
  BaseValidator<T>? get nextValidator => _nextValidator;
  String? validate(T validation);
}
