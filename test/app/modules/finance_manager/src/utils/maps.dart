import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/datetime_extension.dart';

import 'entities.dart';

var expenseTypeMap = <String, dynamic>{
  'expense_type_id': expenseType.id,
  'expense_type_name': expenseType.name,
  'expense_type_icon': expenseType.icon,
};

var incomeTypeMap = <String, dynamic>{
  'income_type_id': incomeType.id,
  'income_type_name': incomeType.name,
  'income_type_icon': incomeType.icon,
};

var paymentMethodMap = <String, dynamic>{
  'payment_method_id': paymentMethod.id,
  'payment_method_name': paymentMethod.name,
  'payment_method_isCredit': paymentMethod.isCredit,
};

var cardMap = <String, dynamic>{
  'credit_card_id': card.id,
  'credit_card_name': card.name,
  'credit_card_annuity': card.annuity,
  'credit_card_color': card.color,
  'credit_card_invCloseDate': card.cardInvoiceClosingDate.date,
  'credit_card_invExpDate': card.cardInvoiceExpirationDate.date,
};

var notificationsMap = <String, dynamic>{
  'notifications_isToSend': notificationsConfiguration.isToSend,
  'notifications_daysBefore': notificationsConfiguration.daysBefore,
  'notifications_hourToSend': notificationsConfiguration.hourToSend.time,
};

var expenseIncludeMap = <String, dynamic>{
  'expense_id': expense.id,
  'expense_value': expense.value,
  'expense_name': expense.name,
  'expense_expDate': expense.expirationDate.date,
  'expense_typeId': expense.type.id,
  'expense_frequency': expense.frequency.index,
  'expense_personName': expense.personName,
};

var expenseReadMap = <String, dynamic>{...expenseIncludeMap, ...expenseTypeMap};

var incomeIncludeMap = <String, dynamic>{
  'income_id': income.id,
  'income_value': income.value,
  'income_name': income.name,
  'income_paymentDay': income.paymentDate.date,
  'income_typeId': income.type.id,
  'income_frequency': income.frequency.index,
  'income_personName': income.personName,
};

var incomeReadMap = <String, dynamic>{...incomeIncludeMap, ...incomeTypeMap};

var expenseParcelIncludeMap = <String, dynamic>{
  'expense_parcel_id': expenseParcel.id,
  'expense_parcel_parcelValue': expenseParcel.parcelValue,
  'expense_parcel_paidValue': expenseParcel.paidValue,
  'expense_parcel_remainingValue': expenseParcel.remainingValue,
  'expense_parcel_expDate': expenseParcel.expirationDate.date,
  'expense_parcel_paymentDate': expenseParcel.paymentDate.date,
  'expense_parcel_paymentMethodId': expenseParcel.paymentMethod.id,
  'expense_parcel_expenseId': expenseParcel.expense.id,
  'expense_parcel_installmentId': null,
};

var expenseParcelReadMap = <String, dynamic>{
  ...expenseParcelIncludeMap,
  ...expenseReadMap,
  ...paymentMethodMap,
};

var incomeParcelIncludeMap = <String, dynamic>{
  'income_parcel_id': incomeParcel.id,
  'income_parcel_parcelValue': incomeParcel.parcelValue,
  'income_parcel_paidValue': incomeParcel.paidValue,
  'income_parcel_remainingValue': incomeParcel.remainingValue,
  'income_parcel_paymentDate': incomeParcel.paymentDate.date,
  'income_parcel_incomeId': incomeParcel.income.id,
};

var incomeParcelReadMap = <String, dynamic>{
  ...incomeParcelIncludeMap,
  ...incomeReadMap,
};

var transactionIncludeMap = <String, dynamic>{
  'transaction_id': transaction.id,
  'transaction_date': transaction.date.date,
  'transaction_value': transaction.value,
  'transaction_incomeParcelId': null,
  'transaction_expenseParcelId': transaction.parcel.id,
};

var transactionReadMap = <String, dynamic>{
  ...transactionIncludeMap,
  ...expenseParcelReadMap,
  ...incomeParcelReadMap,
};

var invoiceItemIncludeMap = <String, dynamic>{
  'invoice_item_invoiceId': invoice.id,
  'invoice_item_parcelId': invoiceItens.first.parcel.id,
  'invoice_item_date': invoiceItens.first.date.date,
  'invoice_item_value': invoiceItens.first.value,
};

var invoiceItemReadMap = <String, dynamic>{
  ...invoiceItemIncludeMap,
  ...expenseParcelReadMap,
};

var invoiceItensReadMapList = List.generate(
  invoiceItens.length,
  (index) => <String, dynamic>{
    'invoice_item_invoiceId': invoice.id,
    'invoice_item_parcelId': invoiceItens[index].parcel.id,
    'invoice_item_date': invoiceItens[index].date.date,
    'invoice_item_value': invoiceItens[index].value,
    ...expenseParcelReadMap,
  },
);

var invoiceIncludeMap = <String, dynamic>{
  'invoice_id': invoice.id,
  'invoice_isClosed': invoice.isClosed,
  'invoice_expDate': invoice.expirationDate.date,
  'invoice_value': invoice.value,
  'invoice_closeDate': invoice.closingDate.date,
  'invoice_cardId': invoice.card.id,
};

var invoiceReadMap = <String, dynamic>{...invoiceIncludeMap, ...cardMap};

var installmentIncludeMap = <String, dynamic>{
  'installment_id': installment.id,
  'installment_parcelsNumber': installment.parcelsNumber,
  'installment_actualParcel': installment.actualParcel,
  'installment_cardId': installment.card?.id,
  'installment_payMethodId': installment.paymentMethod.id,
  'installment_totalValue': installment.totalValue,
  'installment_expenseId': installment.expense.id,
};

var installmentReadMap = <String, dynamic>{
  ...installmentIncludeMap,
  ...cardMap,
  ...expenseReadMap,
  ...paymentMethodMap,
};
