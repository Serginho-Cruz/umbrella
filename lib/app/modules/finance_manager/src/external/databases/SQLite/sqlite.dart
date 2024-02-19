import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/databases/SQLite/population_data.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/databases/SQLite/tables_scripts.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/credit_card_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/expense_type_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/income_type_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/month_table.dart';

import '../../../domain/entities/date.dart';

class SQLite {
  static final instance = SQLite._();
  static Database? _database;

  SQLite._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'umbrella_echonomics.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON;');
  }

  Future<void> _createDatabase(Database db, int version) async {
    await _createTables(db, version);
    await _populateTables(db, version);
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute(incomeTypeTableScript);
    await db.execute(expenseTypeTableScript);
    await db.execute(incomeTableScript);
    await db.execute(expenseTableScript);
    await db.execute(creditCardTableScript);
    await db.execute(invoiceTableScript);
    await db.execute(incomeParcelTableScript);
    await db.execute(expenseParcelTableScript);
    await db.execute(invoiceItemTableScript);
    await db.execute(transactionTableScript);
    await db.execute(paymentMethodTableScript);
    await db.execute(paymentMethodsUsedTableScript);
    await db.execute(installmentTableScript);
    await db.execute(installmentParcelTableScript);
    await db.execute(monthTableScript);
    await db.execute(notificationsConfigurationTableScript);
  }

  Future<void> _populateTables(Database db, int version) async {
    for (var item in expenseTypesMap) {
      await db.insert(ExpenseTypeTable.table, item);
    }

    for (var item in incomeTypesMap) {
      await db.insert(IncomeTypeTable.table, item);
    }

    await db.insert(MonthTable.table, {
      MonthTable.date: Date.today().copyWith(day: 1).toString(),
      MonthTable.initialBalance: 0.0,
      MonthTable.actualBalance: 0.0,
      MonthTable.expectedBalance: 0.0,
      MonthTable.finalBalance: null,
    });

    //For tests only
    await db.insert(CreditCardTable.table, {
      CreditCardTable.name: 'Itaú',
      CreditCardTable.color: 'FF00A6',
      CreditCardTable.annuity: 200.00,
      CreditCardTable.invoiceCloseDate: Date.today().add(days: 10).toString(),
      CreditCardTable.invoiceOverdueDate: Date.today().add(days: 20).toString(),
    });

    await db.insert(CreditCardTable.table, {
      CreditCardTable.name: 'Marisa',
      CreditCardTable.color: '00AAFF',
      CreditCardTable.annuity: 0.00,
      CreditCardTable.invoiceCloseDate: Date.today().add(days: 2).toString(),
      CreditCardTable.invoiceOverdueDate: Date.today().add(days: 12).toString(),
    });

    await db.insert(CreditCardTable.table, {
      CreditCardTable.name: 'Caedu',
      CreditCardTable.color: 'BB15FA',
      CreditCardTable.annuity: 50.00,
      CreditCardTable.invoiceCloseDate: Date.today().add(days: 20).toString(),
      CreditCardTable.invoiceOverdueDate: Date.today().add(days: 30).toString(),
    });
  }
}
