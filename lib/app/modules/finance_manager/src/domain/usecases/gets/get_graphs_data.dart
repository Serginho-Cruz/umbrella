import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';
import '../../entities/account.dart';
import '../../entities/expense_type.dart';
import '../../entities/income_type.dart';
import '../../entities/payment_method.dart';

abstract interface class GetGraphsData {
  AsyncResult<Map<String, double>, Fail> valueOfEachPerson(Account account);
  AsyncResult<Map<ExpenseType, double>, Fail> valueOfEachExpenseType(
    Account account,
  );
  AsyncResult<Map<IncomeType, double>, Fail> valueOfEachIncomeType(
    Account account,
  );
  AsyncResult<Map<PaymentMethod, double>, Fail> valuePaidWithEachMethod(
    Account account,
  );
}
