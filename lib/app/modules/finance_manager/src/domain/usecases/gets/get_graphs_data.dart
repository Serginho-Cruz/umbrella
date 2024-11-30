import 'package:result_dart/result_dart.dart';

import '../../../errors/errors.dart';
import '../../entities/account.dart';
import '../../entities/category.dart';
import '../../entities/payment_method.dart';
import '../../models/status.dart';

abstract interface class GetGraphsData {
  AsyncResult<Map<Category, double>, Fail> valueOfEachExpenseCategory({
    required List<Account> accounts,
    required int month,
    required int year,
  });

  AsyncResult<Map<Category, double>, Fail> valueOfEachIncomeCategory({
    required List<Account> accounts,
    required int month,
    required int year,
  });

  AsyncResult<Map<PaymentMethod, double>, Fail> valuePaidWithEachMethod({
    required List<Account> accounts,
    required int month,
    required int year,
  });

  AsyncResult<Map<Status, double>, Fail> valueForEachExpenseStatus({
    required List<Account> accounts,
    required int month,
    required int year,
  });

  AsyncResult<Map<Status, double>, Fail> valueForEachIncomeStatus({
    required List<Account> accounts,
    required int month,
    required int year,
  });

  AsyncResult<Map<int, double>, Fail> balanceEvolution({
    required List<Account> accounts,
    required int month,
    required int year,
  });
}
