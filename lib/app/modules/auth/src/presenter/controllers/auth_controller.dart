import '../../domain/entities/user.dart';
import '../../domain/usecases/auth.dart';
import 'user_controller.dart';

class AuthController {
  AuthController(this._authUsecase, this._userController);

  final Auth _authUsecase;
  final UserController _userController;
  bool _isLogged = false;
  User? _user;

  bool get isLogged => _isLogged;
  User? get user => _user;

  Future<String?> login({
    required String email,
    required String password,
    bool isToRemember = false,
  }) async {
    var result = await _authUsecase.login(
      email,
      password,
      rememberUser: isToRemember,
    );

    if (result.isError()) {
      return result.exceptionOrNull()!.message;
    }

    _isLogged = true;
    User user = result.getOrNull()!;
    _user = user;
    _userController.update(user);

    return null;
  }

  Future<void> logout() async {
    if (_user == null) {
      _isLogged = false;
      return;
    }

    var result = await _authUsecase.logout(_user!);

    if (result.isSuccess()) {
      _isLogged = false;
      _user = null;
    }
    return;
  }

  Future<String?> _loginWithToken(String token) async {
    var result = await _authUsecase.loginWithToken(token);

    if (result.isError()) {
      return result.exceptionOrNull()!.message;
    }

    _isLogged = true;
    _user = result.getOrNull();

    return null;
  }

  Future<bool> isUserInLocal() async {
    var token = await _userController.searchLocally();

    if (token != null) {
      await _loginWithToken(token);
    }

    return token != null;
  }
}
