import '../../domain/entities/user.dart';

abstract interface class UserDatasource {
  Future<String> register(User user);
  Future<void> update(User newUser);
  Future<User> login(String email, String password);
  Future<User> loginWithToken(String token);
  Future<void> logout(User user);
  Future<void> delete(User user);
}
