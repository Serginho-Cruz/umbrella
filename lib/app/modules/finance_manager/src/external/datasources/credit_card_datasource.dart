import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/credit_card_messages.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/databases/SQLite/sqlite.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/mappers/credit_card_mapper.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/credit_card_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/infra/datasources/icredit_card_datasource.dart';

import '../../errors/errors.dart';

class CreditCardDatasource implements ICreditCardDatasource {
  @override
  Future<int> create(CreditCard card) async {
    var db = await SQLite.instance.database;
    return await db.insert(
      CreditCardTable.table,
      CreditCardMapper.toMap(
        card,
        withId: false,
      ),
    );
  }

  @override
  Future<void> update(CreditCard newCard) async {
    var db = await SQLite.instance.database;
    int changesMade = await db.update(
      CreditCardTable.table,
      CreditCardMapper.toMap(newCard),
      where: '${CreditCardTable.id} = ?',
      whereArgs: [newCard.id],
    );

    if (changesMade != 1) throw Fail(CreditCardMessages.updateError);
  }

  @override
  Future<List<CreditCard>> getAll() async {
    var db = await SQLite.instance.database;

    var cards = await db.query(
      CreditCardTable.table,
      where: '${CreditCardTable.isDeleted} = ?',
      whereArgs: [0],
    );

    return cards.map((e) => CreditCardMapper.fromMap(e)).toList();
  }

  @override
  Future<void> delete(CreditCard card) async {
    var db = await SQLite.instance.database;

    db.rawUpdate(
      'UPDATE ${CreditCardTable.table} SET ${CreditCardTable.isDeleted} = ? WHERE ${CreditCardTable.id} = ?',
      [1, card.id],
    );
  }
}
