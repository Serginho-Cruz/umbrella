import 'package:flutter_modular/flutter_modular.dart';

import 'src/external/temp/datasources/account_datasource.dart';
import 'src/external/temp/datasources/balance_datasource.dart';
import 'src/external/temp/datasources/credit_card_datasource.dart';
import 'src/external/temp/datasources/invoice_datasource.dart';
import 'src/external/temp/datasources/expense_datasource.dart';
import 'src/external/temp/datasources/income_datasource.dart';
import 'src/external/temp/datasources/transaction_datasource.dart';
import 'src/infra/datasources/account_datasource.dart';
import 'src/infra/datasources/balance_datasource.dart';
import 'src/infra/datasources/expense_category_datasource.dart';
import 'src/infra/datasources/transaction_datasource.dart';
import 'src/external/temp/datasources/expense_category_datasource.dart';
import 'src/external/temp/datasources/income_category_datasource.dart';
import 'src/infra/datasources/credit_card_datasource.dart';
import 'src/infra/datasources/invoice_datasource.dart';
import 'src/infra/datasources/expense_datasource.dart';
import 'src/infra/datasources/income_datasource.dart';
import 'src/infra/datasources/income_category_datasource.dart';

abstract class DatasourcesBindings {
  static void bind(Injector i) {
    i.addLazySingleton<AccountDatasource>(TemporaryAccountDatasource.new);

    i.addLazySingleton<BalanceDatasource>(TemporaryBalanceDatasource.new);

    i.addLazySingleton<CreditCardDatasource>(TemporaryCreditCardDatasource.new);

    i.addLazySingleton<InvoiceDatasource>(TemporaryInvoiceDatasource.new);

    i.addLazySingleton<ExpenseCategoryDatasource>(
      TemporaryExpenseCategoryDatasource.new,
    );

    i.addLazySingleton<IncomeCategoryDatasource>(
        TemporaryIncomeCategoryDatasource.new);
    i.addLazySingleton<ExpenseDatasource>(TemporaryExpenseDatasource.new);

    i.addLazySingleton<IncomeDatasource>(TemporaryIncomeDatasource.new);

    i.addLazySingleton<TransactionDatasource>(
        TemporaryTransactionDatasource.new);
  }
}
