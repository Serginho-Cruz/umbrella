import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AccountObject extends ParseObject {
  AccountObject() : super('Account');
}

class BalanceObject extends ParseObject {
  BalanceObject() : super('Balances');
}

class CategoryObject extends ParseObject {
  CategoryObject(super.className);
}

class ExpenseCategoryObject extends CategoryObject {
  ExpenseCategoryObject() : super('ExpenseCategories');
}

class IncomeCategoryObject extends ParseObject {
  IncomeCategoryObject() : super('IncomeCategories');
}

class ExpenseObject extends ParseObject {
  ExpenseObject() : super('Expenses');
}

class IncomeObject extends ParseObject {
  IncomeObject() : super('Incomes');
}

class CreditCardObject extends ParseObject {
  CreditCardObject() : super('CreditCard');
}

class InvoiceObject extends ParseObject {
  InvoiceObject() : super('Invoice');
}

class InvoiceItemObject extends ParseObject {
  InvoiceItemObject() : super('InvoiceItem');
}

class InstallmentObject extends ParseObject {
  InstallmentObject() : super('Installments');
}

class ParcelObject extends ParseObject {
  ParcelObject() : super('Parcels');
}

class PaymentMethodObject extends ParseObject {
  PaymentMethodObject() : super('PaymentMethods');
}

class PaymentRecordObject extends ParseObject {
  PaymentRecordObject() : super('PaymentRecords');
}

class NotificationsConfigurationsObject extends ParseObject {
  NotificationsConfigurationsObject() : super('NotificationsConfigurations');
}
