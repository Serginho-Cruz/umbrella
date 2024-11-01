import 'package:flutter_modular/flutter_modular.dart' show Modular;

abstract class BindServiceProvider {
  /// Returns an instance of type [T].
  ///
  /// If an [identifier] was specified during registration, it must be provided
  /// to retrieve the same instance.
  ///
  /// Example:
  /// ```dart
  /// final myService = BindServiceProvider.get<MyService>();
  /// ```
  static T get<T extends Object>({String? identifier}) {
    return Modular.get(key: identifier);
  }
}
