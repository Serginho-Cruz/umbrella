import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';
import '../../entities/account.dart';
import '../../entities/category.dart';
import '../../entities/payment_method.dart';
import '../../models/status.dart';

abstract interface class GetGraphsData {
  AsyncResult<Map<String, double>, Fail> valueOfEachPerson(
    List<Account> accounts,
  );

  AsyncResult<Map<Category, double>, Fail> valueOfEachExpenseCategory(
    List<Account> accounts,
  );

  AsyncResult<Map<Category, double>, Fail> valueOfEachIncomeCategory(
    List<Account> accounts,
  );

  AsyncResult<Map<PaymentMethod, double>, Fail> valuePaidWithEachMethod(
    List<Account> accounts,
  );

  AsyncResult<Map<Status, double>, Fail> valueForEachExpenseStatus(
    List<Account> accounts,
  );

  AsyncResult<Map<Status, double>, Fail> valueForEachIncomeStatus(
    List<Account> accounts,
  );
}
