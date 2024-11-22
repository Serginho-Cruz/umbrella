import 'base_validator.dart';

class ValidationChain<T extends Object?> {
  final List<BaseValidator<T>> _validators;

  ValidationChain(this._validators);

  String? validate(T validation) {
    for (var i = 0; i < _validators.length - 1; i++) {
      _validators[i].setNextValidator(_validators[i + 1]);
    }

    return _validators[0].validate(validation);
  }
}
