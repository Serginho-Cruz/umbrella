import 'package:flutter_modular/flutter_modular.dart' show Injector;

import '../src/infra/datasources/interfaces.dart';
import '../src/external/implementations.dart';

abstract class DatasourcesBindings {
  static void bind(Injector i) {
    i.addLazySingleton<AccountDatasource>(Back4AppAccountDatasource.new);

    i.addLazySingleton<BalanceDatasource>(Back4AppBalanceDatasource.new);

    i.addLazySingleton<CreditCardDatasource>(
      Back4AppCreditCardDatasource.new,
    );

    i.addLazySingleton<InvoiceDatasource>(Back4AppInvoiceDatasource.new);

    i.addLazySingleton<ExpenseCategoryDatasource>(
      Back4AppExpenseCategoryDatasource.new,
    );

    i.addLazySingleton<IncomeCategoryDatasource>(
      Back4AppIncomeCategoryDatasource.new,
    );

    i.addLazySingleton<ExpenseDatasource>(Back4AppExpenseDatasource.new);

    i.addLazySingleton<IncomeDatasource>(Back4AppIncomeDatasource.new);

    i.addLazySingleton<PaymentRecordDatasource>(
      Back4AppPaymentRecordDatasource.new,
    );

    i.addLazySingleton<PaymentMethodDatasource>(
      TemporaryPaymentMethodDatasource.new,
    );
  }
}
