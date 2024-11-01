import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AccountObject extends ParseObject {
  AccountObject() : super('Account');
}

class BalanceObject extends ParseObject {
  BalanceObject() : super('Balance');
}

class CategoryObject extends ParseObject {
  CategoryObject(super.className);
}

class ExpenseCategoryObject extends CategoryObject {
  ExpenseCategoryObject() : super('ExpenseCategory');
}

class IncomeCategoryObject extends ParseObject {
  IncomeCategoryObject() : super('IncomeCategory');
}

class ExpenseObject extends ParseObject {
  ExpenseObject() : super('Expense');
}

class FrequentExpenseObject extends ParseObject {
  FrequentExpenseObject() : super('FrequentExpense');
}

class IncomeObject extends ParseObject {
  IncomeObject() : super('Income');
}

class FrequentIncomeObject extends ParseObject {
  FrequentIncomeObject() : super('FrequentIncome');
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
  InstallmentObject() : super('Installment');
}

class ParcelObject extends ParseObject {
  ParcelObject() : super('Parcel');
}

class PaymentMethodObject extends ParseObject {
  PaymentMethodObject() : super('PaymentMethod');
}

class PaymentRecordObject extends ParseObject {
  PaymentRecordObject() : super('PaymentRecord');
}

class NotificationsConfigurationsObject extends ParseObject {
  NotificationsConfigurationsObject() : super('NotificationsConfiguration');
}
