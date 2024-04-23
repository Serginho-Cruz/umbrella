import 'package:flutter_triple/flutter_triple.dart';

import '../../domain/entities/user.dart';

class UserController extends Store<User> {
  UserController() : super(_UnloggedUser());

  Future<User?> searchLocally() async {
    return null;
    // return User(
    //   id: 0,
    //   username: 'Sergio 1234',
    //   email: '',
    //   password: '12345678',
    // );
  }
}

class _UnloggedUser extends User {
  _UnloggedUser() : super(id: 0, email: '', password: '', name: '');
}
