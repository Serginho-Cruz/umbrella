import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/expense_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/expense_type_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/income_parcel_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/income_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/income_type_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/installment_parcel_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/installment_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/invoice_item_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/invoice_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/month_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/notifications_configuration_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/payment_method_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/payment_methods_used_table.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/transaction_table.dart';

import '../../schemas/credit_card_table.dart';
import '../../schemas/expense_parcel_table.dart';

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
    ${IncomeTable.value} REAL NOT NULL,
    ${IncomeTable.frequency} INTEGER NOT NULL,
    ${IncomeTable.paymentDate} TEXT NOT NULL,
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
    ${ExpenseTable.value} REAL NOT NULL,
    ${ExpenseTable.overdueDate} TEXT,
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
    ${InvoiceTable.closeDate} TEXT NOT NULL,
    ${InvoiceTable.overdueDate} TEXT NOT NULL,
    ${InvoiceTable.isClosed} BOOLEAN NOT NULL,
    ${InvoiceTable.cardId} INTEGER NOT NULL,
    FOREIGN KEY(${InvoiceTable.cardId}) REFERENCES ${CreditCardTable.table}(${CreditCardTable.id})
  )
  ''';
}

String get incomeParcelTableScript {
  return '''
  
  CREATE TABLE IF NOT EXISTS ${IncomeParcelTable.table} (
    ${IncomeParcelTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${IncomeParcelTable.totalValue} REAL NOT NULL,
    ${IncomeParcelTable.paidValue} REAL NOT NULL,
    ${IncomeParcelTable.remainingValue} REAL NOT NULL,
    ${IncomeParcelTable.overdueDate} TEXT NOT NULL,
    ${IncomeParcelTable.paymentDate} TEXT,
    ${IncomeParcelTable.incomeId} INTEGER NOT NULL,
    FOREIGN KEY(${IncomeParcelTable.incomeId}) REFERENCES ${IncomeTable.table}(${IncomeTable.id})
  )
  ''';
}

String get expenseParcelTableScript {
  return '''
   CREATE TABLE IF NOT EXISTS ${ExpenseParcelTable.table} (
    ${ExpenseParcelTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${ExpenseParcelTable.totalValue} REAL NOT NULL,
    ${ExpenseParcelTable.paidValue} REAL NOT NULL,
    ${ExpenseParcelTable.remainingValue} REAL NOT NULL,
    ${ExpenseParcelTable.overdueDate} TEXT NOT NULL,
    ${ExpenseParcelTable.paymentDate} TEXT,
    ${ExpenseParcelTable.expenseId} INTEGER NOT NULL,
    FOREIGN KEY(${ExpenseParcelTable.expenseId}) REFERENCES ${ExpenseTable.table}(${ExpenseTable.id})
  )
  ''';
}

String get invoiceItemTableScript {
  return '''
  CREATE TABLE IF NOT EXISTS ${InvoiceItemTable.table} (
    ${InvoiceItemTable.parcelId} INTEGER NOT NULL,
    ${InvoiceItemTable.invoiceId} INTEGER NOT NULL,
    ${InvoiceItemTable.date} TEXT NOT NULL,
    ${InvoiceItemTable.value} REAl NOT NULL,
    PRIMARY KEY(${InvoiceItemTable.invoiceId}, ${InvoiceItemTable.parcelId}),
    FOREIGN KEY(${InvoiceItemTable.invoiceId}) REFERENCES ${InvoiceTable.table}(${InvoiceTable.id}),
    FOREIGN KEY(${InvoiceItemTable.parcelId}) REFERENCES ${ExpenseParcelTable.table}(${ExpenseParcelTable.id})
  )
  ''';
}

String get transactionTableScript {
  return '''
  CREATE TABLE IF NOT EXISTS ${TransactionTable.table} (
    ${TransactionTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${TransactionTable.value} REAL NOT NULL,
    ${TransactionTable.date} TEXT NOT NULL,
    ${TransactionTable.incomeParcelId} INTEGER,
    ${TransactionTable.expenseParcelId} INTEGER,
    ${TransactionTable.invoiceId} INTEGER,
    FOREIGN KEY(${TransactionTable.incomeParcelId}) REFERENCES ${IncomeParcelTable.table}(${IncomeParcelTable.id}),
    FOREIGN KEY(${TransactionTable.expenseParcelId}) REFERENCES ${ExpenseParcelTable.table}(${ExpenseParcelTable.id}),
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
    ${PaymentMethodsUsedTable.expenseParcelId} INTEGER,
    PRIMARY KEY(${PaymentMethodsUsedTable.paymentMethodId}, ${PaymentMethodsUsedTable.expenseParcelId}, ${PaymentMethodsUsedTable.invoiceId}),
    FOREIGN KEY(${PaymentMethodsUsedTable.paymentMethodId}) REFERENCES ${PaymentMethodTable.table}(${PaymentMethodTable.id}),
    FOREIGN KEY(${PaymentMethodsUsedTable.expenseParcelId}) REFERENCES ${ExpenseParcelTable.table}(${ExpenseParcelTable.id}),
    FOREIGN KEY(${PaymentMethodsUsedTable.invoiceId}) REFERENCES ${InvoiceTable.table}(${InvoiceTable.id})
  )
  ''';
}

String get installmentTableScript {
  return '''
  CREATE TABLE IF NOT EXISTS ${InstallmentTable.table} (
    ${InstallmentTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${InstallmentTable.totalValue} REAL NOT NULL,
    ${InstallmentTable.parcelsNumber} INTEGER NOT NULL,
    ${InstallmentTable.actualParcel} INTEGER,
    ${InstallmentTable.nextParcel} INTEGER,
    ${InstallmentTable.cardId} INTEGER NOT NULL,
    ${InstallmentTable.expenseParcelId} INTEGER NOT NULL,
    FOREIGN KEY(${InstallmentTable.cardId}) REFERENCES ${CreditCardTable.table}(${CreditCardTable.id}),
    FOREIGN KEY(${InstallmentTable.expenseParcelId}) REFERENCES ${ExpenseParcelTable.table}(${ExpenseParcelTable.id})
  )
  ''';
}

String get installmentParcelTableScript {
  return '''
  CREATE TABLE IF NOT EXISTS ${InstallmentParcelTable.table} (
    ${InstallmentParcelTable.installmentId} INTEGER NOT NULL,
    ${InstallmentParcelTable.expenseParcelId} INTEGER NOT NULL,
    ${InstallmentParcelTable.parcelNumber} INTEGER NOT NULL,
    PRIMARY KEY(${InstallmentParcelTable.installmentId}, ${InstallmentParcelTable.expenseParcelId}),
    FOREIGN KEY(${InstallmentParcelTable.installmentId}) REFERENCES ${InstallmentTable.table}(${InstallmentTable.id}),
    FOREIGN KEY(${InstallmentParcelTable.expenseParcelId}) REFERENCES ${ExpenseParcelTable.table}(${ExpenseParcelTable.id})
  )
  ''';
}

String get monthTableScript {
  return '''
  CREATE TABLE IF NOT EXISTS ${MonthTable.table} (
    ${MonthTable.date} TEXT NOT NULL,
    ${MonthTable.initialBalance} REAL NOT NULL,
    ${MonthTable.actualBalance} REAL NOT NULL,
    ${MonthTable.expectedBalance} REAL NOT NULL,
    ${MonthTable.finalBalance} REAL
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
