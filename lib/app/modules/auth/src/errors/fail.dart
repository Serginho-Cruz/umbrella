abstract class Fail implements Exception {
  final String _message;

  const Fail(this._message);

  String get message => _message;
}
