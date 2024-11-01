import 'package:mobx/mobx.dart';
import 'package:result_dart/result_dart.dart' show Result;

import '../../domain/entities/user.dart';
import '../../domain/entities/user_state.dart';
import '../../domain/usecases/auth.dart';
import '../../domain/usecases/manage_local_token.dart';
import '../../domain/usecases/manage_user.dart';
import '../../common/errors/fail.dart';
import '../../domain/usecases/validate.dart';
part 'auth_store.g.dart';

// ignore: library_private_types_in_public_api
class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  final Auth _auth;
  final ManageUser _manageUser;
  final ManageLocalToken _manageLocalToken;
  final Validate _validate;

  _AuthStoreBase({
    required Auth auth,
    required ManageUser manageUser,
    required ManageLocalToken manageLocalToken,
    required Validate validateFields,
  })  : _auth = auth,
        _manageUser = manageUser,
        _manageLocalToken = manageLocalToken,
        _validate = validateFields;

  @observable
  UserState state = const InitialState();

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  String name = '';

  @observable
  String confirmPassword = '';

  @observable
  bool isToRemember = false;

  @observable
  bool isPasswordVisible = false;

  Future<void> login() async {
    if (state is LoadingState) return;

    _setLoading();

    var result = await _auth.login(email, password, rememberUser: isToRemember);

    _foldUserResult(result, onUser: resetFields);
  }

  @action
  Future<void> logout() async {
    if (state is! SuccessState) return;

    User user = (state as SuccessState).user;

    _setLoading();

    var result = await _auth.logout(user);

    result.fold((_) {
      state = const InitialState();
    }, (fail) {
      state = FailState(fail);
    });
  }

  @action
  Future<void> register() async {
    if (state is LoadingState) return;

    _setLoading();

    User user = User(
      id: '',
      email: email,
      name: name,
      password: password,
    );

    var result = await _manageUser.register(user);

    result.fold((_) {
      state = const InitialState();
    }, (fail) {
      state = FailState(fail);
    });
  }

  Future<void> update() async {
    if (state is! SuccessState) return;

    User oldUser = (state as SuccessState).user;
    User newUser = User(
      id: oldUser.id,
      email: email,
      name: name,
      password: password,
      token: oldUser.token,
    );

    if (oldUser == newUser) return;

    _setLoading();

    var result = await _manageUser.update(oldUser, newUser);

    _foldUserResult(result.pure(newUser), onUser: resetFields);
  }

  @action
  Future<void> delete() async {
    if (state is! SuccessState) return;

    User user = (state as SuccessState).user;

    _setLoading();

    var deleteRes = await _manageUser.delete(user);

    if (deleteRes.isError()) {
      state = FailState(deleteRes.exceptionOrNull()!);
    } else {
      state = const InitialState();
    }

    _manageLocalToken.delete();
  }

  Future<bool> isUserInLocal() async {
    if (state is SuccessState) return true;

    var result = await _manageLocalToken.get();

    if (result.isError()) return false;

    String token = result.getOrDefault('');

    var loginResult = await _auth.loginWithToken(token);

    _foldUserResult(loginResult);

    return state is SuccessState;
  }

  @action
  void setName(String name) {
    this.name = name;
  }

  @action
  void setEmail(String email) {
    this.email = email;
  }

  @action
  void setPassword(String password) {
    this.password = password;
  }

  @action
  void setConfirmPassword(String confirmPassword) {
    this.confirmPassword = confirmPassword;
  }

  @action
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
  }

  @action
  void setRememberUser(bool isToRemember) {
    this.isToRemember = isToRemember;
  }

  String? validateEmail(String? email) => _validate.email(email);

  String? validatePassword(
    String? password, {
    PasswordValidationMode mode = PasswordValidationMode.full,
  }) =>
      _validate.password(password, mode: mode);

  String? validateName(String? name) => _validate.name(name);

  String? validateConfirmPassword(String? confirmPassword) =>
      _validate.confirmPassword(password, confirmPassword);

  @action
  void resetFields() {
    name = '';
    email = '';
    password = '';
    confirmPassword = '';
    isToRemember = false;
    isPasswordVisible = false;
  }

  @action
  void _setLoading() {
    state = const LoadingState();
  }

  @action
  void _foldUserResult(
    Result<User, Fail> result, {
    void Function()? onUser,
    void Function()? onFail,
  }) {
    result.fold((user) {
      state = SuccessState(user);
      onUser?.call();
    }, (fail) {
      state = FailState(fail);
      onFail?.call();
    });
  }
}
