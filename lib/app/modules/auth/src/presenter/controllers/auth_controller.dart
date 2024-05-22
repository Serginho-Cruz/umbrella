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
    var result = await _authUsecase.login(email, password);

    if (result.isError()) {
      return result.exceptionOrNull()!.message;
    }

    _isLogged = true;
    User user = result.getOrNull()!;
    _user = user;
    _userController.update(user);

    if (isToRemember) {
      _userController.setInLocal(user);
    }
    return null;
  }

  Future<String?> logout() async {
    var result = await _authUsecase.logout();

    if (result.isSuccess()) {
      _isLogged = false;
      _user = null;
    }
    return result.exceptionOrNull()?.message;
  }

  Future<bool> isUserInLocal() async {
    var user = await _userController.searchLocally();

    if (user != null) {
      login(email: user.email, password: user.password, isToRemember: true);
    }

    return user != null;
  }
}
