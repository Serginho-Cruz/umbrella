import '../../domain/entities/user.dart';

abstract interface class UserDatasource {
  Future<int> register(User user);
  Future<void> update(User newUser);
  Future<User> getByEmail(String email);
  Future<void> setLastLogin(User user);
  Future<void> delete(User user);
}
