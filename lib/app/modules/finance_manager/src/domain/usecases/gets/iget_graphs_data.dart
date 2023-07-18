import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';
import '../../entities/credit_card.dart';
import '../../entities/expense_type.dart';
import '../../entities/income_type.dart';
import '../../entities/payment_method.dart';

abstract class IGetGraphsData {
  Future<Result<Map<String, double>, Fail>> valueOfEachPerson();
  Future<Result<Map<ExpenseType, double>, Fail>> valueOfEachExpenseType();
  Future<Result<Map<IncomeType, double>, Fail>> valueOfEachIncomeType();
  Future<Result<Map<CreditCard, double>, Fail>> invoiceValueOfEachCard();
  Future<Result<Map<PaymentMethod, double>, Fail>>
      numberOfParcelsPaidWithEachMethod();
}
