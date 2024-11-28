import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_record.dart';

import '../../errors/errors.dart';
import '../entities/credit_card.dart';

abstract interface class PayExpense {
  AsyncResult<Unit, Fail> withoutCredit(PaymentRecord<Expense> expense);
  AsyncResult<Unit, Fail> withCredit(
    PaymentRecord<Expense> expense,
    CreditCard card,
  );
}
