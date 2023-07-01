import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_type.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_type.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/installment.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice_item.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/notifications_configuration.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/transaction.dart';

var card = CreditCard(
  id: 1,
  name: "Nubank",
  annuity: 200.0,
  color: 'ffffff',
  cardInvoiceClosingDate: DateTime(2023, 2, 3),
  cardInvoiceExpirationDate: DateTime(2023, 2, 18),
);

var expenseType = ExpenseType(id: 1, name: "Shopping", icon: "shopping_icon");

var incomeType = IncomeType(id: 1, name: "Salary", icon: "salary_icon");

var notificationsConfiguration = NotificationsConfiguration(
  isToSend: true,
  daysBefore: 7,
  hourToSend: DateTime(2023, 2, 3, 20, 30),
);

var paymentMethod = PaymentMethod(
  id: 1,
  name: 'Credit',
  icon: 'credit_icon.png',
  isCredit: true,
);

var expense = Expense(
  id: 1,
  value: 200.0,
  name: 'Supermarket',
  expirationDate: DateTime(2023, 2, 3),
  type: expenseType,
  frequency: Frequency.none,
  personName: null,
);

var income = Income(
  id: 1,
  name: 'Salary',
  value: 1200.0,
  paymentDate: DateTime(2023, 2, 3),
  frequency: Frequency.monthly,
  type: incomeType,
  personName: null,
);

var expenseParcel = ExpenseParcel(
  expense: expense,
  expirationDate: DateTime(2023, 2, 5),
  paymentMethod: paymentMethod,
  id: 1,
  paidValue: 200.0,
  remainingValue: 500.0,
  paymentDate: DateTime(2023, 2, 3),
  parcelValue: 700.0,
);

var incomeParcel = IncomeParcel(
  income: income,
  id: 1,
  paidValue: 200.0,
  remainingValue: 500.0,
  paymentDate: DateTime(2023, 2, 3),
  parcelValue: 700.0,
);

var transaction = Transaction(
  id: 1,
  value: 200.0,
  date: DateTime(2023, 1, 3),
  parcel: expenseParcel,
);

var invoiceItens = [
  InvoiceItem(parcel: expenseParcel, date: DateTime(2023, 2, 4), value: 500.0),
  InvoiceItem(parcel: expenseParcel, date: DateTime(2023, 2, 5), value: 500.0),
];

var invoice = Invoice(
  id: 1, // get the sum of values of invoice itens
  value: invoiceItens.reduce((item1, item) => item1..value += item.value).value,
  isClosed: false,
  expirationDate: DateTime(2023, 2, 10),
  closingDate: DateTime(2023, 2, 5),
  card: card,
  itens: invoiceItens,
);

var installment = Installment(
  id: 1,
  parcelsNumber: 2,
  actualParcel: 1,
  expense: expense,
  totalValue: (expenseParcel.parcelValue * 2 * 10).roundToDouble() / 10,
  paymentMethod: paymentMethod,
  parcels: [expenseParcel, expenseParcel],
  card: card,
);
