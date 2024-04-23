import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/errors/auth_fail.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/errors/user_fail.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/infra/datasources/user_datasource.dart';
import 'package:umbrella_echonomics/app/modules/core/src/mysql_connection_provider.dart';

import '../../../../finance_manager/src/domain/entities/date.dart';
import '../../domain/entities/user_mapper.dart';
import '../../errors/messages.dart';
import 'user_table_schema.dart';

class MySqlUserDatasource implements UserDatasource {
  final MysqlConnectionProvider _provider;

  MySqlUserDatasource(this._provider);

  @override
  Future<int> register(User user) async {
    var conn = await _provider.getConnection();

    var results = await conn.query(
      '''
      INSERT INTO ${UserTable.table}(${UserTable.name}, ${UserTable.email}, ${UserTable.password}, ${UserTable.isToReminder}) 
      VALUES(?, ?, ?, ?);
    ''',
      [user.name, user.email, user.password, user.isToReminder],
    );

    if (results.insertId == null) {
      throw DatabaseProcessError(Messages.registerUserError);
    }

    return results.insertId!;
  }

  @override
  Future<void> update(User newUser) async {
    var conn = await _provider.getConnection();

    var results = await conn.query(
      '''
      UPDATE ${UserTable.table} SET ${UserTable.name} = ?, ${UserTable.email} = ?, ${UserTable.password} = ?, ${UserTable.isToReminder} = ? 
      WHERE ${UserTable.id} = ?;
    ''',
      [
        newUser.name,
        newUser.email,
        newUser.password,
        newUser.isToReminder,
        newUser.id,
      ],
    );

    if (results.affectedRows! < 1) {
      throw DatabaseProcessError(Messages.updateUserError);
    }
  }

  @override
  Future<User> getByEmail(String email) async {
    var conn = await _provider.getConnection();

    var results = await conn.query('''
      SELECT * from ${UserTable.table} WHERE ${UserTable.email} = ?;
    ''', [email]);

    if (results.isEmpty) {
      throw UserNotFoundWithEmail(email);
    }

    return UserMapper.fromMap(results.first.fields);
  }

  @override
  Future<void> setLastLogin(User user) async {
    var conn = await _provider.getConnection();

    var results = await conn.query(
      '''
      UPDATE ${UserTable.table} SET ${UserTable.lastLogin} = ? 
      WHERE ${UserTable.id} = ?;
    ''',
      [Date.today().toString(separator: '-'), user.id],
    );

    if (results.affectedRows! < 1) {
      throw DatabaseProcessError(Messages.updateUserError);
    }
  }

  @override
  Future<void> delete(User user) async {
    var conn = await _provider.getConnection();

    var results = await conn.query(
      '''
      UPDATE ${UserTable.table} SET ${UserTable.isDeleted} = ? WHERE ${UserTable.id} = ?;
      ''',
      [true, user.id],
    );

    if (results.affectedRows! < 1) {
      throw DatabaseProcessError(Messages.deleteUserError);
    }
  }
}
