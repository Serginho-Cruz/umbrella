import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/filters/ifilter_transactions.dart';

abstract class TransactionTypeFactory {
  static TransactionType generate() {
    var types = <int, TransactionType>{
      0: TransactionType.expense,
      1: TransactionType.income,
      2: TransactionType.invoice,
    };

    return types[faker.randomGenerator.integer(3)]!;
  }
}
