import 'dart:convert';

import '../../external/datasources/user_table_schema.dart';
import 'user.dart';

abstract final class UserMapper {
  static Map<String, dynamic> toMap(User user, {withId = true}) {
    return {
      if (withId) UserTable.id: user.id,
      UserTable.name: user.name,
      UserTable.email: user.email,
      UserTable.password: user.password,
      UserTable.isToReminder: user.isToReminder,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map[UserTable.id] as int,
      name: map[UserTable.name] as String,
      email: map[UserTable.email] as String,
      password: map[UserTable.password] as String,
      isToReminder: map[UserTable.isToReminder] as bool,
    );
  }

  static String toJson(User user) {
    return json.encode(UserMapper.toMap(user));
  }

  static User fromJson(String jsonObject) {
    var map = json.decode(jsonObject);
    return UserMapper.fromMap(map);
  }
}
