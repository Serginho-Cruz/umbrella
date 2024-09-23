import 'package:flutter_modular/flutter_modular.dart';
import '../src/external/back4app/datasources/account_datasource.dart';
import '../src/external/back4app/datasources/balance_datasource.dart';
import '../src/external/back4app/datasources/credit_card_datasource.dart';
import '../src/external/back4app/datasources/expense_category_datasource.dart';
import '../src/external/back4app/datasources/expense_datasource.dart';
import '../src/external/back4app/datasources/income_category_datasource.dart';
import '../src/external/back4app/datasources/income_datasource.dart';
import '../src/external/back4app/datasources/invoice_datasource.dart';
import '../src/external/back4app/datasources/payment_record_datasource.dart';
import '../src/external/temp/datasources/payment_method_datasource.dart';
import '../src/infra/datasources/payment_method_datasource.dart';

import '../src/infra/datasources/account_datasource.dart';
import '../src/infra/datasources/balance_datasource.dart';
import '../src/infra/datasources/expense_category_datasource.dart';
import '../src/infra/datasources/payment_record_datasource.dart';
import '../src/infra/datasources/credit_card_datasource.dart';
import '../src/infra/datasources/invoice_datasource.dart';
import '../src/infra/datasources/expense_datasource.dart';
import '../src/infra/datasources/income_datasource.dart';
import '../src/infra/datasources/income_category_datasource.dart';

abstract class DatasourcesBindings {
  static void bind(Injector i) {
    i.addLazySingleton<AccountDatasource>(Back4AppAccountDatasource.new);

    i.addLazySingleton<BalanceDatasource>(Back4AppBalanceDatasource.new);

    i.addLazySingleton<CreditCardDatasource>(Back4AppCreditCardDatasource.new);

    i.addLazySingleton<InvoiceDatasource>(Back4AppInvoiceDatasource.new);

    i.addLazySingleton<ExpenseCategoryDatasource>(
        Back4AppExpenseCategoryDatasource.new);

    i.addLazySingleton<IncomeCategoryDatasource>(
        Back4AppIncomeCategoryDatasource.new);
    i.addLazySingleton<ExpenseDatasource>(Back4AppExpenseDatasource.new);

    i.addLazySingleton<IncomeDatasource>(Back4AppIncomeDatasource.new);

    i.addLazySingleton<PaymentRecordDatasource>(
        Back4AppPaymentRecordDatasource.new);

    i.addLazySingleton<PaymentMethodDatasource>(
        TemporaryPaymentMethodDatasource.new);
  }
}
