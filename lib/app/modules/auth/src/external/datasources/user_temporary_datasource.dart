import '../../domain/entities/user.dart';
import '../../errors/user_fail.dart';
import '../../infra/datasources/user_datasource.dart';

class UserTemporaryDatasource implements UserDatasource {
  final List<User> _users;

  UserTemporaryDatasource()
      : _users = [
          User(
            id: 1,
            email: 'user1@gmail.com',
            name: 'Usuário 1',
            password: '12345678',
          ),
          User(
            id: 2,
            email: 'user2@gmail.com',
            name: 'Usuário 2',
            password: '12345678',
          ),
          User(
            id: 3,
            email: 'user3@gmail.com',
            name: 'Usuário 3',
            password: '12345678',
          ),
        ];

  @override
  Future<int> register(User user) async {
    int id = _users.last.id + 1;
    _users.add(user.copyWith(id: id));

    return id;
  }

  @override
  Future<void> delete(User user) async {
    int i = 0;
    for (i = 0; i < _users.length; i++) {
      if (_users[i].id == user.id) {
        _users.removeAt(i);
        break;
      }
    }

    if (i == _users.length) {
      throw GenericUserFail();
    }
  }

  @override
  Future<User> getByEmail(String email) async {
    for (var user in _users) {
      if (email == user.email) return user;
    }

    throw UserDoesntExist();
  }

  @override
  Future<void> setLastLogin(User user) {
    return Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<void> update(User newUser) async {
    int i;
    for (i = 0; i < _users.length; i++) {
      if (_users[i].id == newUser.id) {
        _users.removeAt(i);
        _users.insert(i, newUser);
        break;
      }
    }

    if (_users.length == i) {
      throw UserDoesntExist();
    }
  }
}
