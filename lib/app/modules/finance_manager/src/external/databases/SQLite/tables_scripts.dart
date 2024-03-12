import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/expense_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/expense_type_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/income_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/income_type_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/installment_parcel_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/installment_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/invoice_item_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/invoice_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/balance_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/notifications_configuration_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/payment_method_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/payment_methods_used_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/transaction_table.dart';

import '../../schemas/credit_card_table.dart';

String get incomeTypeTableScript {
  return '''
  CREATE TABLE IF NOT EXISTS ${IncomeTypeTable.table} (
    ${IncomeTypeTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${IncomeTypeTable.name} TEXT NOT NULL,
    ${IncomeTypeTable.icon} TEXT NOT NULL
  )
  ''';
}

String get incomeTableScript {
  return '''
  CREATE TABLE IF NOT EXISTS ${IncomeTable.table} (
    ${IncomeTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${IncomeTable.name} TEXT NOT NULL,
    ${IncomeTable.totalValue} REAL NOT NULL,
        ${IncomeTable.paidValue} REAL NOT NULL,
    ${IncomeTable.remainingValue} REAL NOT NULL,
    ${IncomeTable.dueDate} TEXT NOT NULL,
    ${IncomeTable.paymentDate} TEXT,
    ${IncomeTable.frequency} INTEGER NOT NULL,
    ${IncomeTable.lastInsertDate} TEXT NOT NULL,
    ${IncomeTable.typeId} INTEGER NOT NULL,
    ${IncomeTable.personName} TEXT,
    FOREIGN KEY(${IncomeTable.typeId}) REFERENCES ${IncomeTypeTable.table}(${IncomeTypeTable.id})
  )
  ''';
}

String get expenseTypeTableScript {
  return '''
  CREATE TABLE IF NOT EXISTS ${ExpenseTypeTable.table} (
    ${ExpenseTypeTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${ExpenseTypeTable.name} TEXT NOT NULL,
    ${ExpenseTypeTable.icon} TEXT NOT NULL
  )
  ''';
}

String get expenseTableScript {
  return '''
  
  CREATE TABLE IF NOT EXISTS ${ExpenseTable.table}(
    ${ExpenseTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${ExpenseTable.name} TEXT NOT NULL,
    ${ExpenseTable.totalValue} REAL NOT NULL,
        ${ExpenseTable.paidValue} REAL NOT NULL,
    ${ExpenseTable.remainingValue} REAL NOT NULL,
    ${ExpenseTable.overdueDate} TEXT NOT NULL,
    ${ExpenseTable.paymentDate} TEXT,
    ${ExpenseTable.frequency} INTEGER NOT NULL,
    ${ExpenseTable.typeId} INTEGER NOT NULL,
    FOREIGN KEY(${ExpenseTable.typeId}) REFERENCES ${ExpenseTypeTable.table}(${ExpenseTypeTable.id}) 
  )
  ''';
}

String get creditCardTableScript {
  return '''
  CREATE TABLE IF NOT EXISTS ${CreditCardTable.table}(
    ${CreditCardTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${CreditCardTable.name} TEXT NOT NULL,
    ${CreditCardTable.annuity} REAL NOT NULL,
    ${CreditCardTable.color} TEXT NOT NULL,
    ${CreditCardTable.invoiceCloseDate} TEXT NOT NULL,
    ${CreditCardTable.invoiceOverdueDate} TEXT NOT NULL,
    ${CreditCardTable.isDeleted} BOOLEAN NOT NULL DEFAULT 0
  )
  ''';
}

String get invoiceTableScript {
  return '''
  
  CREATE TABLE IF NOT EXISTS ${InvoiceTable.table} (
    ${InvoiceTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${InvoiceTable.value} REAL NOT NULL,
        ${InvoiceTable.iof} REAL NOT NULL,
    ${InvoiceTable.interest} REAL NOT NULL,
    ${InvoiceTable.paidValue} REAL NOT NULL,
    ${InvoiceTable.remainingValue} REAL NOT NULL,
    ${InvoiceTable.closeDate} TEXT NOT NULL,
    ${InvoiceTable.overdueDate} TEXT NOT NULL,
    ${InvoiceTable.paymentDate} TEXT,
    ${InvoiceTable.cardId} INTEGER NOT NULL,
    FOREIGN KEY(${InvoiceTable.cardId}) REFERENCES ${CreditCardTable.table}(${CreditCardTable.id})
  )
  ''';
}

String get invoiceItemTableScript {
  return '''
  CREATE TABLE IF NOT EXISTS ${InvoiceItemTable.table} (
    ${InvoiceItemTable.expenseId} INTEGER NOT NULL,
    ${InvoiceItemTable.invoiceId} INTEGER NOT NULL,
    ${InvoiceItemTable.date} TEXT NOT NULL,
    ${InvoiceItemTable.value} REAl NOT NULL,
    PRIMARY KEY(${InvoiceItemTable.invoiceId}, ${InvoiceItemTable.expenseId}),
    FOREIGN KEY(${InvoiceItemTable.invoiceId}) REFERENCES ${InvoiceTable.table}(${InvoiceTable.id}),
    FOREIGN KEY(${InvoiceItemTable.expenseId}) REFERENCES ${ExpenseTable.table}(${ExpenseTable.id})
  )
  ''';
}

String get transactionTableScript {
  return '''
  CREATE TABLE IF NOT EXISTS ${TransactionTable.table} (
    ${TransactionTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${TransactionTable.value} REAL NOT NULL,
    ${TransactionTable.date} TEXT NOT NULL,
    ${TransactionTable.incomeId} INTEGER,
    ${TransactionTable.expenseId} INTEGER,
    ${TransactionTable.invoiceId} INTEGER,
    FOREIGN KEY(${TransactionTable.incomeId}) REFERENCES ${IncomeTable.table}(${IncomeTable.id}),
    FOREIGN KEY(${TransactionTable.expenseId}) REFERENCES ${ExpenseTable.table}(${ExpenseTable.id}),
    FOREIGN KEY(${TransactionTable.invoiceId}) REFERENCES ${InvoiceTable.table}(${InvoiceTable.id})
  )
  ''';
}

String get paymentMethodTableScript {
  return '''
  CREATE TABLE IF NOT EXISTS ${PaymentMethodTable.table} (
    ${PaymentMethodTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${PaymentMethodTable.name} TEXT NOT NULL,
    ${PaymentMethodTable.icon} TEXT NOT NULL
  )
  ''';
}

String get paymentMethodsUsedTableScript {
  return '''
  CREATE TABLE IF NOT EXISTS ${PaymentMethodsUsedTable.table} (
    ${PaymentMethodsUsedTable.paymentMethodId} INTEGER NOT NULL,
    ${PaymentMethodsUsedTable.invoiceId} INTEGER,
    ${PaymentMethodsUsedTable.expenseId} INTEGER,
    PRIMARY KEY(${PaymentMethodsUsedTable.paymentMethodId}, ${PaymentMethodsUsedTable.expenseId}, ${PaymentMethodsUsedTable.invoiceId}),
    FOREIGN KEY(${PaymentMethodsUsedTable.paymentMethodId}) REFERENCES ${PaymentMethodTable.table}(${PaymentMethodTable.id}),
    FOREIGN KEY(${PaymentMethodsUsedTable.expenseId}) REFERENCES ${ExpenseTable.table}(${ExpenseTable.id}),
    FOREIGN KEY(${PaymentMethodsUsedTable.invoiceId}) REFERENCES ${InvoiceTable.table}(${InvoiceTable.id})
  )
  ''';
}

String get installmentTableScript {
  return '''
  CREATE TABLE IF NOT EXISTS ${InstallmentTable.table} (
    ${InstallmentTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${InstallmentTable.value} REAL NOT NULL,
    ${InstallmentTable.parcelsNumber} INTEGER NOT NULL,
    ${InstallmentTable.actualParcel} INTEGER,
    ${InstallmentTable.nextParcel} INTEGER,
    ${InstallmentTable.cardId} INTEGER NOT NULL,
    ${InstallmentTable.expenseId} INTEGER NOT NULL,
    FOREIGN KEY(${InstallmentTable.cardId}) REFERENCES ${CreditCardTable.table}(${CreditCardTable.id}),
    FOREIGN KEY(${InstallmentTable.expenseId}) REFERENCES ${ExpenseTable.table}(${ExpenseTable.id})
  )
  ''';
}

String get installmentParcelTableScript {
  return '''
  CREATE TABLE IF NOT EXISTS ${InstallmentParcelTable.table} (
    ${InstallmentParcelTable.installmentId} INTEGER NOT NULL,
    ${InstallmentParcelTable.parcelNumber} INTEGER NOT NULL,
    PRIMARY KEY(${InstallmentParcelTable.installmentId}, ${InstallmentParcelTable.parcelNumber}),
    FOREIGN KEY(${InstallmentParcelTable.installmentId}) REFERENCES ${InstallmentTable.table}(${InstallmentTable.id})
  )
  ''';
}

String get balanceTableScript {
  return '''
  CREATE TABLE IF NOT EXISTS ${BalanceTable.table} (
    ${BalanceTable.month} TEXT NOT NULL,
    ${BalanceTable.initial} REAL NOT NULL,
    ${BalanceTable.actual} REAL NOT NULL,
    ${BalanceTable.expected} REAL NOT NULL,
    ${BalanceTable.last} REAL
  )
  ''';
}

String get notificationsConfigurationTableScript {
  return '''
  CREATE TABLE IF NOT EXISTS ${NotificationsConfigurationTable.table}(
    ${NotificationsConfigurationTable.daysBefore} INTEGER NOT NULL,
    ${NotificationsConfigurationTable.timeToSend} TEXT NOT NULL,
    ${NotificationsConfigurationTable.isToSend} BOOLEAN NOT NULL
  )
  ''';
}
