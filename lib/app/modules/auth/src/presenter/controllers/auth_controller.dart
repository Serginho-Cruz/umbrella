import '../../domain/entities/user.dart';
import '../../domain/usecases/auth.dart';
import 'user_controller.dart';

class AuthController {
  AuthController(this._authUsecase, this._userController);

  final Auth _authUsecase;
  final UserController _userController;
  bool isLogged = false;

  Future<String?> login({
    required String email,
    required String password,
    bool isToRemember = false,
  }) async {
    var result = await _authUsecase.login(email, password);

    if (result.isError()) {
      return result.exceptionOrNull()!.message;
    }

    isLogged = true;
    User user = result.getOrNull()!;
    _userController.update(user);

    if (isToRemember) {
      _userController.setInLocal(user);
    }
    return null;
  }

  Future<String?> logout() async {
    var result = await _authUsecase.logout();
    return result.exceptionOrNull()?.message;
  }

  Future<bool> isUserInLocal() async {
    var user = await _userController.searchLocally();

    return user != null;
  }
}
