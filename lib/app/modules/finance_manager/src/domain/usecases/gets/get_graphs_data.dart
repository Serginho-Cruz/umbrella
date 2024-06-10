import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';
import '../../entities/account.dart';
import '../../entities/category.dart';
import '../../entities/payment_method.dart';

abstract interface class GetGraphsData {
  AsyncResult<Map<String, double>, Fail> valueOfEachPerson(Account account);
  AsyncResult<Map<Category, double>, Fail> valueOfEachExpenseCategory(
    Account account,
  );
  AsyncResult<Map<Category, double>, Fail> valueOfEachIncomeCategory(
    Account account,
  );
  AsyncResult<Map<PaymentMethod, double>, Fail> valuePaidWithEachMethod(
    Account account,
  );
}
